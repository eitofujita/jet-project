# 7. Rails

## 学習目標

Railsの「設定より規約」という思想、MVC、リクエスト処理の流れ、主要ディレクトリの責務を理解します。generatorに任せきりにせず、生成されたコードとルーティングを説明できることを目指します。

## Railsアプリケーション

```bash
rails new mini_instagram -d postgresql
cd mini_instagram
bin/rails db:create
bin/rails server
```

プロジェクトでは`rails`より`bin/rails`を使うと、Gemfileで固定したRailsを実行できます。`config/database.yml`やcredentialsへ秘密情報を直書きしてコミットせず、環境変数や暗号化credentialsを使います。

## MVCとリクエストの流れ

1. RouterがHTTPメソッドとパスをController actionへ対応付ける。
2. Controllerが入力を受け、認証・認可を行い、Modelやサービスを呼ぶ。
3. Modelがデータと業務上の整合性を扱う。
4. Viewがレスポンスの表現を組み立てる。

ControllerへSQL相当の複雑な検索や業務ルールを詰め込まず、Viewから保存処理を起動しません。MVCはファイルを三分類するだけでなく、変更理由を分離するための境界です。

## ルーティング

```ruby
Rails.application.routes.draw do
  root "feeds#show"
  resources :posts do
    resources :comments, only: %i[create destroy]
    resource :like, only: %i[create destroy]
  end
end
```

```bash
bin/rails routes
```

`resources`はRESTに対応する複数ルートを生成します。単数`resource`はユーザーと投稿の組み合わせでLikeが一つというインターフェースを表せます。不要なactionは`only`で限定し、公開面を小さくします。

## ディレクトリ

- `app/models`: データと業務ルール
- `app/controllers`: HTTP入力とレスポンス制御
- `app/views`: HTMLなどの表現
- `config`: route、環境、初期化設定
- `db/migrate`: スキーマ変更手順
- `spec`: RSpecテスト
- `public`: そのまま配信する静的ファイル
- `log` / `tmp`: 実行時生成物

## generatorとデータベース

```bash
bin/rails generate model Post user:references caption:text
bin/rails db:migrate
bin/rails generate controller Posts index show
```

generatorは出発点です。生成されたmigrationの型、null制約、外部キー、indexを必ず確認します。不要なファイルやルートを生成したままにしないでください。マイグレーション適用後に単純にファイルを削除してもデータベースは戻りません。

## 環境と設定

development、test、productionは別環境です。本番だけで発生する問題を減らすには、環境差を理解し、環境変数の不足を起動時に検出します。`Rails.env`による分岐を業務コードへ散らすより、設定値や依存を注入します。

## Instagramクローンへの応用

まずUser、Post、Follow、Comment、Likeの関係を設計し、投稿一覧の縦切り機能を小さく完成させます。モデル、route、controller、view、testを一機能ずつ接続すると、層の役割を確認しながら進められます。

## 演習と確認

1. `resources :posts`が生成する各ルートをHTTPメソッドとactionで説明してください。
2. `/posts/:id`へのGETがレスポンスになるまでの処理を追跡してください。
3. 投稿一覧と詳細だけを持つControllerを作る設計を書いてください。

- MVC各層の責務を説明できる
- `bin/rails routes`でルートを確認できる
- generatorの出力をレビューできる
- developmentとtestのデータベースが別である理由を説明できる
