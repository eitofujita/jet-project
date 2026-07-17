#0 GIT

#1 Hello Ruby

#2 - Блок-схемы и типы данных
(Block diagrams and data types)

#3 - Работа с файлами
(Working with files)

#4 - Классы и модули
(Classes and modules)

#5 - Тестирование. Rspec
(Testing. RSpec)

#6 - HTTP сервер
(HTTP server)

#7 - Rails

#8 - Database (part 1)

#9 - Database (part 2)

#10 - Debugging (Ruby/Rails)

#11 - Active Record

#12 - Controllers & Authentication

#13 - Authorization + live code

#14 - Views

#15 - Rspec + сдача проектов
(RSpec + Project submission)


Проект 


В разрезе курсового мы будем писать свой Instagram. В миниатюре конечно. 😅

Почему? Минимальный набор функционала инсты довольно хорошо позволяет разобраться со всеми основными аспектами веб приложений.

Функционал

👉 A user can sign up for an account

👉 A user can log in to their account

👉 A user can post an image

👉 A user can edit post he owns

👉 A user can follow another user

👉 A user can unfollow another user

👉 A user can view his/her feed

👉 A user can leave comment

👉 A user can remove his/her comments

👉 A user can see comments

👉 A user can like/dislike (if liked previously) posts

👉 A user can view the number of likes on a post

---

## まとめ（日本語）

> 詳細な学習教材は **[Ruby / Railsカリキュラム教材](docs/curriculum/README.md)** にあります。GitとRubyの基礎から、データベース、認証・認可、View、RSpec、プロジェクト提出までを章ごとに解説しています。

> 実装したファイルの役割とDockerfileを含む構成の説明は **[作成内容と構成](docs/IMPLEMENTATION.md)** にあります。

### カリキュラム（#0〜#15）

| # | 内容 |
|---|------|
| 0 | Git |
| 1 | Hello Ruby |
| 2 | ブロック図とデータ型 |
| 3 | ファイル操作 |
| 4 | クラスとモジュール |
| 5 | テスト（RSpec） |
| 6 | HTTP サーバー |
| 7 | Rails |
| 8-9 | Database（パート1・2） |
| 10 | Debugging（Ruby/Rails） |
| 11 | Active Record |
| 12 | Controllers & Authentication |
| 13 | Authorization + live code |
| 14 | Views |
| 15 | RSpec + プロジェクト提出 |

### プロジェクト概要

コースの最終プロジェクトとして、**小規模な Instagram クローン** を作成する。Web アプリの主要な要素を一通り学ぶための題材となっている。

### 必要な機能

- ユーザー登録・ログイン ok
- 画像投稿 ok
- 自分の投稿の編集 ok
- フォロー / アンフォロー 
- フィード表示 
- コメントの投稿・削除・閲覧 ok
- 投稿へのいいね / いいね解除 ok
- 投稿のいいね数表示 ok

---

## 開発方針

このプロジェクトでは、RailsのMVC、HTTP、データベース、認証・認可を一つずつ理解することを優先し、RailsがHTMLを生成する標準的な構成を採用する。

画面はERBで作成し、デザインにはCSSまたはTailwind CSSを使用する。ページ遷移やLike数、コメント一覧などの部分更新にはTurboを使用し、Turboだけで表現しにくい小さな操作にStimulusを使用する。Railsだけでも投稿一覧、画像表示、フォロー、コメント、Likeなどの必要機能は実装できる。

フロントエンドを別アプリケーションへ分離する構成は採用しない。HTML生成、フォーム処理、validationエラーの表示、認証済みセッション、画面の部分更新までをRailsアプリケーション内で一貫して実装する。

## 技術構成

| 分類 | 採用技術 | 役割 |
|---|---|---|
| プログラミング言語 | Ruby 3.2.3 | サーバー側の処理と業務ロジック |
| Webフレームワーク | Rails 8.1.3 | MVC、ルーティング、DB接続、画面生成 |
| HTMLテンプレート | ERB | Rubyの値を使用したHTML生成 |
| スタイル | CSS / Tailwind CSS | レイアウトとデザイン |
| 画面更新 | Turbo | ページ遷移と部分更新 |
| JavaScript | Stimulus | 必要な箇所だけの対話的な処理 |
| データベース | SQLite 3（sqlite3 gem 2.9.5） | ユーザー、投稿、関係データの永続化 |
| 画像管理 | Active Storage | 投稿画像の保存と参照 |
| 認証 | `has_secure_password` | パスワードのハッシュ化とログイン |
| 認可 | Pundit | 投稿編集やコメント削除などの権限判定 |
| テスト | RSpec / Capybara | モデル、HTTP、ブラウザ操作の検証 |
| コード品質 | RuboCop | Rubyコードの静的解析 |
| セキュリティ検査 | Brakeman | Railsに関する脆弱性の検査 |
| バージョン管理 | Git | 変更履歴とブランチ管理 |

当初はRuby 3.3以降とPostgreSQLを予定していたが、WSLのAPT権限によりシステムパッケージを導入できなかったため、確認のうえRuby 3.2.3とSQLiteへ変更した。Railsとgemのバージョンは`.ruby-version`、`Gemfile`、`Gemfile.lock`に固定している。Ruby 3.2は保守期間が終了しているため、環境修復後はRuby 3.3以降へ更新する。

## セットアップ

```bash
bundle install
bin/rails db:prepare
bin/rails tailwindcss:build
bin/rails server
```

開発サーバーとTailwind CSSの監視を同時に起動する場合は、次を使用する。

```bash
bin/dev
```

テストと品質検査は次のコマンドで実行する。

```bash
bundle exec rspec
bin/rubocop
bin/brakeman --no-pager
```

BrakemanはRuby 3.2の保守終了を警告する。これは現在のWSL環境制約による既知の問題であり、アプリケーションコードの警告とは分けて扱う。

## RSpecの導入方針

RSpecは最終段階だけで追加するのではなく、カリキュラムの`#5 テスト（RSpec）`で基本を導入し、それ以降の実装で継続して使用する。機能をすべて作った後からテストを追加すると、テストしにくい設計や隠れた依存関係が残りやすいため、各機能の実装とテストを同じ作業単位として進める。

### #5で学ぶ内容

- `describe`、`context`、`it`による仕様の整理
- `expect`とmatcherによる期待結果の検証
- 正常系、異常系、境界値のテスト設計
- `let`、`subject`、テストダブルの基本
- テスト失敗時のメッセージとスタックトレースの読み方

この段階では、データベースやRailsに依存しないRubyクラスを対象にして、入力、戻り値、状態変化、例外を検証する。

### #7以降での使用方法

Railsを導入した後は、モデルや各機能を実装するたびに対応するRSpecを追加する。

- Model spec: validation、関連、scope、業務ルール
- Policy spec: 所有者、別ユーザー、管理者の権限
- Request spec: routing、認証、Strong Parameters、HTTPステータス、DB変更
- System spec: 登録、ログイン、投稿、フォロー、コメント、Likeの主要操作

### #15で仕上げる内容

`#15 RSpec + プロジェクト提出`ではRSpecを初めて導入するのではなく、それまでに作成したテスト全体を整理する。重複したテストの削減、不足する異常系の追加、Factoryの改善、CIでの自動実行、提出前の全体確認を行う。

## プロジェクト構成

Railsアプリケーションはリポジトリ直下へ配置し、学習教材は既存の`docs/curriculum`へ残す。

```text
jet-project/
├── app/
│   ├── controllers/     # HTTPリクエストとレスポンス
│   ├── jobs/            # 通知などの非同期処理
│   ├── models/          # データ、関連、validation
│   ├── policies/        # 操作権限の判定
│   ├── services/        # 複数モデルにまたがる処理
│   └── views/           # ERBによる画面
├── config/
│   ├── routes.rb        # URLとControllerの対応
│   └── database.yml     # データベース接続設定
├── db/
│   ├── migrate/         # スキーマ変更履歴
│   ├── schema.rb        # 現在のDB構造
│   └── seeds.rb         # 開発用初期データ
├── docs/
│   └── curriculum/      # Ruby / Rails学習教材
├── spec/
│   ├── factories/       # テストデータの定義
│   ├── models/          # モデルテスト
│   ├── policies/        # 認可テスト
│   ├── requests/        # HTTPリクエストテスト
│   └── system/          # ブラウザ操作テスト
├── storage/             # 開発環境の画像保存先
├── Gemfile
├── Gemfile.lock
└── README.md
```

## データモデル

### User

ユーザーのメールアドレス、ユーザー名、パスワードダイジェストを管理する。Userは複数のPost、Comment、Likeを持つ。フォロー関係では、フォローする側とフォローされる側の両方になる。

### Post

投稿者、本文、投稿日時、画像を管理する。画像はPostの列へ直接保存せず、Active Storageを通して関連付ける。投稿の編集・削除は原則として所有者だけに許可する。

### Comment

コメント本文、作成者、対象投稿を管理する。コメントは一つのUserと一つのPostに属し、削除は作成者または管理者だけに許可する。

### Like

Likeしたユーザーと対象投稿の関係を管理する。同じユーザーが同じ投稿へ複数回Likeできないように、モデルのvalidationだけでなくデータベースにも複合一意インデックスを設定する。

### Follow

フォローするユーザーとフォローされるユーザーの自己参照関係を管理する。自己フォローと同じ組み合わせの重複を禁止する。フォロー関係はフィードに表示する投稿を決定するために使用する。

```text
User ──< Post
User ──< Comment >── Post
User ──< Like >──── Post
User ──< Follow >── User
Post ─── Image（Active Storage）
```

## 実装状況

### 第1段階: 開発環境と基礎

- [x] Ruby、Rails、SQLiteのバージョンを確認して固定する。
- [x] Railsアプリケーションを初期化する。
- [x] RSpec、RuboCop、Brakemanを設定する。
- [x] development、testのデータベースを作成する。
- [x] Tailwind CSS、Turbo、Stimulusを設定する。

### 第2段階: ユーザーと認証

- [x] Userモデルとデータベース制約を作成する。
- [x] ユーザー登録画面を実装する。
- [x] セッションを使用したログイン・ログアウトを実装する。
- [x] `has_secure_password`でパスワードをハッシュ化する。
- [x] 未ログインユーザーから保護対象ページへのアクセスを制限する。

### 第3段階: 投稿と画像

- [x] PostモデルとUserとの関連を作成する。
- [x] Active Storageによる画像投稿を実装する。
- [x] 投稿一覧、詳細、新規作成、編集、削除を実装する。
- [x] 画像形式、5MBの容量上限、2,200文字の本文長を検証する。
- [x] Punditで所有者以外の編集・削除を禁止する。

### 第4段階: フォローとフィード

- [x] Followモデルと自己参照関連を作成する。
- [x] フォローとアンフォローを実装する。
- [x] モデルとDB制約で自己フォローと重複フォローを禁止する。
- [x] フォロー中ユーザーと自分の投稿を新しい順に表示する。
- [x] 関連を先読みし、フィードを最大30件に制限する。

### 第5段階: コメントとLike

- [x] Commentモデルと投稿・ユーザーとの関連を作成する。
- [x] コメントの作成、一覧、所有者削除を実装する。
- [x] Likeモデルを作成し、Likeと解除を実装する。
- [x] 投稿ごとのLike件数を表示する。
- [x] Turbo Streamでコメント一覧とLike表示を部分更新する。

### 第6段階: 品質確認と提出

- [x] Model、Policy、Request、System specを整備する。
- [x] 未認証、不正入力、他人のリソース、重複操作を検証する。
- [x] RuboCopとBrakemanを実行する。
- [x] フィードと投稿一覧で関連を先読みする。
- [x] READMEへセットアップと検証手順を記載する。

## カリキュラム#0〜#15と成果物の対応

| # | テーマ | このプロジェクトでの成果物・確認内容 |
|---|---|---|
| 0 | Git | Gitリポジトリと`.gitignore`を作成し、秘密情報と生成物を除外 |
| 1 | Hello Ruby | モデル、サービス、ControllerをRubyで実装 |
| 2 | フローチャートとデータ型 | 登録、投稿、Like、Followの正常系・異常系を条件分岐として設計 |
| 3 | ファイル操作 | Active Storageで画像ファイルを安全に保存・検証 |
| 4 | クラスとモジュール | モデル責務、`FeedQuery`、Policyへ処理を分離 |
| 5 | RSpec | Factory、Model spec、境界値・例外・重複操作を検証 |
| 6 | HTTPサーバー | RESTful route、HTTPメソッド、status、redirect、Turboレスポンスを実装 |
| 7 | Rails | MVC、ERB、Tailwind CSS、Turbo、Stimulusでアプリを構成 |
| 8 | Database Part 1 | 5モデル、主キー、外部キー、NOT NULL制約をmigrationで定義 |
| 9 | Database Part 2 | 複合一意index、CHECK制約、関連の先読み、安定した並び順を実装 |
| 10 | Debugging | Railsログ、RSpec失敗、静的解析結果から不具合を修正 |
| 11 | Active Record | association、validation、scope、Active Storageを実装 |
| 12 | Controllerと認証 | Strong Parameters、セッション、`has_secure_password`を実装 |
| 13 | 認可 | Punditで投稿編集、コメント削除、Follow操作を制御 |
| 14 | View | ERB、partial、form helper、Turbo Stream、XSS対策、基本的なアクセシビリティを実装 |
| 15 | RSpecと提出 | 35件のspec、RuboCop、Brakeman、セットアップ手順を整備 |

## 既知の制約

- Ruby 3.2.3は保守期間が終了しているため、環境修復後にRuby 3.3以降へ更新する必要がある。
- PostgreSQLを導入できないWSL環境のため、現在はSQLiteを使用している。本番運用前にはPostgreSQLへ移行し、同時実行時の制約動作を再検証する。
- フィードは最大30件であり、次ページを取得するUIはまだ実装していない。
- 画像は開発環境のローカルストレージへ保存する。本番ではS3互換ストレージなどを設定する必要がある。
