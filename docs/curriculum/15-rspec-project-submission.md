# 15. RSpecとプロジェクト提出

## 学習目標

Railsアプリをモデル、request、systemの各層でテストし、重要なリスクを過不足なく覆います。第三者が再現可能なREADME、セットアップ手順、品質確認結果を揃えて提出できることを目指します。

## テスト戦略

- Model spec: validation、関連、業務ルール、scope
- Request spec: route、認証、認可、parameters、status、DB変更
- System spec: ブラウザ上の重要な利用者フロー
- Job / mailer spec: 非同期処理、通知内容、再試行時の安全性

同じ詳細を全層で重複検証せず、ルールは高速な下位層、層同士の接続と重要フローは上位層で確認します。カバレッジ率だけを目標にすると、assertionの弱いテストが増えるため、障害時の影響と発生可能性から優先します。

## Model spec

```ruby
RSpec.describe Like, type: :model do
  subject(:like) { build(:like, user: user, post: post) }

  let(:user) { create(:user) }
  let(:post) { create(:post) }

  it "同じ投稿への二重Likeを拒否する" do
    create(:like, user: user, post: post)

    expect(like).not_to be_valid
    expect(like.errors[:user_id]).to be_present
  end
end
```

DBのunique indexも必要なので、migration/schemaの確認や競合時の例外処理も別途テストします。

## Request spec

```ruby
RSpec.describe "PATCH /posts/:id", type: :request do
  it "別ユーザーの投稿を更新しない" do
    owner = create(:user)
    attacker = create(:user)
    post_record = create(:post, user: owner, caption: "original")
    sign_in(attacker)

    patch post_path(post_record), params: { post: { caption: "changed" } }

    expect(post_record.reload.caption).to eq("original")
    expect(response).to have_http_status(:not_found)
  end
end
```

レスポンスだけでなく、DBが変更されていないことも検証します。認証helperが実際の仕組みを過度に迂回しないようにします。

## System spec

登録、ログイン、画像投稿、フォロー、フィード表示、コメント、Likeという主要フローを少数のsystem specで確認します。CSSセレクタへ依存しすぎず、label、button名、`data-testid`など安定した契約を使います。時刻待ちの`sleep`ではなく、Capybaraの待機機構を使います。

## Factoryとテストデータ

Factoryは有効な最小データを既定とし、管理者や非公開投稿などの差はtraitで表します。callbackが大量の関連データを自動生成すると、テストが遅く前提が不透明になります。各例で必要なデータだけを作り、固定IDや実行順序に依存しません。

## CIと提出前確認

CIでは依存導入、test DB準備、静的解析、セキュリティ検査、RSpecを毎回同じ手順で実行します。ローカルだけ通る場合は、未コミットファイル、環境変数、DB状態、時刻・locale依存を疑います。

```bash
bundle install
bin/rails db:prepare
bundle exec rspec
bin/rubocop
bin/brakeman
```

利用できるコマンドはプロジェクト構成に合わせます。警告を無条件で無効化せず、理由を記録します。

## READMEと提出物

READMEには目的、主要機能、技術構成、対応バージョン、セットアップ、環境変数名、DB準備、起動、テスト、設計判断、既知の制約を記載します。秘密値そのものは載せません。migration、Gemfile.lock、必要な設定例、ライセンス、画面資料を確認し、空の環境から手順を再実行します。

## Instagramクローンへの応用

最終成果では、登録、ログイン、画像投稿、所有者による編集、フォロー、フィード、コメント、Likeという要件を、READMEの機能一覧とテストへ対応付けます。各機能について正常系だけでなく、未認証、不正入力、他人のリソース、重複操作を確認します。画像ストレージやメールなど外部サービスが必要なら、開発・テスト・本番ごとの設定方法と、認証情報を含まない環境変数例を記載します。

## 最終確認

1. 未ログイン、別ユーザー、無効入力を含む重要フローをテストする。
2. N+1、無制限一覧、巨大画像、機密ログを確認する。
3. `git status`と差分を確認し、秘密情報・生成物を除外する。
4. 新規clone相当の環境でREADMEの手順を実行する。
5. 未実装事項や既知の問題を隠さず明記する。

- テスト層を目的に応じて選べる
- 認可では「変更されないこと」も検証できる
- 再現可能なFactoryとCIを構成できる
- READMEだけで第三者が起動・テストできる
- セキュリティ、性能、アクセシビリティも提出品質に含められる
