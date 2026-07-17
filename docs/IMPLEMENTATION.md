# 作成内容と構成

この文書は、Instagramクローンとして作成したファイルの役割、実装済み機能、テスト構成、Railsが自動生成した運用ファイルについて説明する。

## 1. アプリケーションの全体像

このプロジェクトは、Reactなどの別フロントエンドを持たないRailsアプリケーションである。Railsがデータベース操作、認証・認可、HTML生成、フォーム処理を担当する。

```text
ブラウザ
  ↓ HTTPリクエスト
Routes
  ↓
Controller ── Policy
  ↓
Model / Service
  ↓
SQLite / Active Storage
  ↓
ERB + Tailwind CSS + Turbo
  ↓ HTTPレスポンス
ブラウザ
```

主要な技術は次のとおり。

- Ruby 3.2.3
- Rails 8.1.3
- SQLite
- ERB
- Tailwind CSS
- Turbo / Stimulus
- Active Storage
- RSpec
- Pundit

Ruby 3.3以降とPostgreSQLを予定していたが、WSLのシステムパッケージ管理領域へ書き込めないため、ユーザー確認後にRuby 3.2.3とSQLiteへ変更した。

## 2. モデルとデータベース

### `app/models/user.rb`

ユーザー名、メールアドレス、パスワードを管理する。`has_secure_password`によりパスワードそのものではなくハッシュを保存する。投稿、コメント、Like、フォロー関係を持つ。

### `app/models/post.rb`

投稿本文と投稿者を管理し、Active Storageで画像を関連付ける。画像が添付されていること、JPEG・PNG・WebPであること、5MB以下であること、本文が2,200文字以下であることを検証する。

### `app/models/comment.rb`

投稿へのコメントを管理する。コメントはユーザーと投稿に属し、空文字列と500文字を超える本文を拒否する。

### `app/models/like.rb`

ユーザーと投稿のLike関係を管理する。同じユーザーが同じ投稿へ二重にLikeできないように、モデルのvalidationとデータベースの複合一意indexを併用する。

### `app/models/follow.rb`

ユーザー同士のフォロー関係を管理する。`follower`がフォローする側、`followed`がフォローされる側である。自己フォローはモデルとCHECK制約で禁止し、重複フォローはvalidationと複合一意indexで禁止する。

### `db/migrate/`

User、Post、Comment、Like、Follow、Active Storageのテーブルを作成する。NOT NULL、外部キー、一意index、CHECK制約をデータベース側にも定義している。

## 3. ControllerとHTTP処理

### `app/controllers/application_controller.rb`

現在のログインユーザーを取得し、未認証ユーザーをログイン画面へ移動する。Punditの認可エラーも共通処理する。

### `app/controllers/users_controller.rb`

アカウント登録とプロフィール表示を担当する。登録成功後はセッションを再生成してログイン状態にする。

### `app/controllers/sessions_controller.rb`

ログインとログアウトを担当する。メールアドレスとパスワードが正しい場合だけ、セッションへユーザーIDを保存する。

### `app/controllers/posts_controller.rb`

投稿一覧、詳細、作成、編集、更新、削除を担当する。投稿者IDをフォームから受け取らず、ログイン中のユーザーから投稿を構築する。

### `app/controllers/feeds_controller.rb`

ログインユーザー向けフィードを表示する。実際の検索条件は`FeedQuery`へ分離している。

### `app/controllers/comments_controller.rb`

コメントの作成と削除を担当する。成功時にはTurbo Streamを返し、JavaScriptを使用しない通常のHTMLリクエストにはredirectを返す。

### `app/controllers/likes_controller.rb`

LikeとLike解除を担当する。二重リクエストでも同じLikeが重複しないように処理し、Turbo Streamで表示を更新する。

### `app/controllers/follows_controller.rb`

フォローとフォロー解除を担当する。操作する側は必ずログイン中のユーザーに固定する。

## 4. 認可

`app/policies/`にはPunditのPolicyを配置している。

- `post_policy.rb`: 投稿の所有者または管理者だけが編集・削除できる。
- `comment_policy.rb`: コメント作成者または管理者だけが削除できる。
- `user_policy.rb`: 自分自身以外のユーザーだけをフォローできる。

画面でボタンを隠すだけでなく、ControllerでもPolicyを実行するため、URLやリクエストを直接変更しても権限を回避できない。

## 5. フィード

`app/services/feed_query.rb`は、ログインユーザー本人とフォロー中ユーザーの投稿を新しい順に最大30件取得する。投稿者、画像、Like、コメントを先読みしてN+1問題を避ける。

フィード検索をControllerから分離することで、HTTP処理と検索条件の責務を分けている。

## 6. View

`app/views/`にはERBテンプレートを配置している。

- `layouts/application.html.erb`: 共通ナビゲーション、通知、エラー表示
- `users/new.html.erb`: アカウント登録
- `sessions/new.html.erb`: ログイン
- `users/show.html.erb`: プロフィール、フォロー操作、投稿一覧
- `feeds/show.html.erb`: フォロー関係に基づくフィード
- `posts/_form.html.erb`: 投稿作成・編集の共通フォーム
- `posts/_post.html.erb`: 投稿カード
- `posts/show.html.erb`: 投稿詳細とコメント
- `comments/_comment.html.erb`: コメント表示
- `likes/_like_button.html.erb`: Likeボタンと件数
- `comments/*.turbo_stream.erb`: コメント部分更新
- `likes/*.turbo_stream.erb`: Like部分更新

外部入力はERBの自動エスケープを維持し、`raw`や`html_safe`を使用していない。フォームにはlabel、必須属性、文字数制限を設定している。

## 7. スタイルとJavaScript

### `app/assets/tailwind/application.css`

Tailwind CSSの入力ファイルである。`bin/rails tailwindcss:build`によって、ブラウザへ配信するCSSを`app/assets/builds/tailwind.css`へ生成する。

### `app/javascript/`

TurboとStimulusの初期設定が含まれる。現時点の主要な部分更新はTurbo Streamで実装しているため、独自JavaScriptは最小限である。

## 8. RSpec

`spec/`には次のテストを配置している。

- `spec/models/`: validation、正規化、画像、重複Like、自己フォロー
- `spec/policies/`: 所有者と別ユーザーの権限
- `spec/requests/`: 認証、HTTP status、DB変更、Turbo Stream
- `spec/system/`: ブラウザ操作によるユーザー登録
- `spec/factories/`: テストデータ

実行方法：

```bash
bundle exec rspec
```

現在は35件のexampleがあり、すべて成功している。

## 9. 品質・セキュリティ

```bash
RUBOCOP_CACHE_ROOT=tmp/rubocop_cache bin/rubocop
bin/brakeman --no-pager
```

RuboCopではコード規約を確認する。BrakemanではRailsアプリケーションの脆弱性を検査する。アプリケーションコードに警告はないが、通常のBrakeman実行ではRuby 3.2の保守終了警告が出る。

## 10. Dockerfileが存在する理由

`Dockerfile`、`.dockerignore`、`config/deploy.yml`、`.kamal/`は、Rails 8の`rails new`が標準で生成した本番デプロイ用ファイルである。このプロジェクトでDocker開発環境を選択したために追加したものではない。

Dockerfileには次の目的がある。

1. Rubyと必要なOSパッケージを含む本番実行環境を再現する。
2. gemとassetsをbuild stageで準備し、最終imageを小さくする。
3. rootではない`rails`ユーザーでアプリを実行する。
4. ThrusterとPumaを使ってコンテナ内でRailsを起動する。
5. Kamalから同じimageをサーバーへ配布できるようにする。

ローカル開発ではDockerfileを使用していない。通常は次のコマンドで起動する。

```bash
bin/dev
```

現時点ではDocker自体が環境へ導入されていないため、Dockerfileのbuild検証は行っていない。ただしRails標準の本番デプロイ構成として残している。ローカル学習だけを目的とし、今後もコンテナ配布やKamalを使用しないことが確定した場合は、Dockerfile、`.dockerignore`、`.kamal/`、`config/deploy.yml`、Kamal関連gemをまとめて削除できる。関連ファイルを一部だけ削除すると設定が不整合になるため、削除する場合は一式で判断する。

## 11. 起動方法

```bash
bundle install
bin/rails db:prepare
bin/dev
```

ブラウザで`http://localhost:3000`を開き、アカウント登録から利用する。

## 12. 既知の制約

- Ruby 3.2.3は保守期間が終了している。
- PostgreSQLではなくSQLiteを使用している。
- フィードは最大30件で、次ページを取得するUIは未実装である。
- 画像はローカルストレージへ保存する。
- Docker imageは未検証である。
