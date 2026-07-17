# Ruby / Rails カリキュラム

この教材は、Rubyの基礎からRailsによるWebアプリケーション開発までを、Instagram風アプリの実装と結び付けて学ぶためのものです。用語を暗記するのではなく、「なぜその仕組みが必要か」「どの場面で使うか」「誤ると何が起きるか」を説明できる状態を目指します。

## 想定する学習環境

- Ruby 3系
- Bundler
- Rails 7以降
- PostgreSQLまたはSQLite
- Git

Railsや各gemはバージョンによってAPIが変わることがあります。コマンドが教材どおりに動かない場合は、`ruby --version`、`rails --version`、`bundle exec rails --version`を確認し、プロジェクトのバージョンに対応する公式ドキュメントも参照してください。

## 教材の使い方

1. 各章の「学習目標」を読み、何を説明できるようになるべきか確認する。
2. コード例を写すだけでなく、値や条件を変えて実行結果を予測する。
3. 「よくある誤り」を読み、自分でエラーを再現して原因を確かめる。
4. 演習を、答えを見る前に小さな単位へ分解して実装する。
5. Instagramクローンへの応用を通して、章同士のつながりを確認する。
6. 最後のチェックリストを、自分の言葉で説明できるか確認する。

## 学習順序

### RubyとWebの基礎

0. [Git](00-git.md)
1. [Hello Ruby](01-hello-ruby.md)
2. [フローチャートとデータ型](02-flowcharts-and-data-types.md)
3. [ファイル操作](03-working-with-files.md)
4. [クラスとモジュール](04-classes-and-modules.md)
5. [RSpecによるテスト](05-testing-rspec.md)
6. [HTTPサーバー](06-http-server.md)

### Railsとデータベース

7. [Rails](07-rails.md)
8. [Database Part 1](08-database-part-1.md)
9. [Database Part 2](09-database-part-2.md)
10. [Ruby / Railsのデバッグ](10-debugging-ruby-rails.md)
11. [Active Record](11-active-record.md)
12. [Controllerと認証](12-controllers-authentication.md)
13. [認可と実装演習](13-authorization-live-code.md)
14. [View](14-views.md)
15. [RSpecとプロジェクト提出](15-rspec-project-submission.md)

## 最終プロジェクトで扱う関係

- `User`はアカウントを登録し、セッションを使ってログインする。
- `Post`は投稿者と画像を持ち、所有者だけが編集できる。
- `Follow`はユーザー同士の関係を表し、フィードの取得条件になる。
- `Comment`はユーザーと投稿に属し、作成者だけが削除できる。
- `Like`はユーザーと投稿の組み合わせを一意にし、二重いいねを防ぐ。

機能を一度に完成させず、モデルと制約、HTTPインターフェース、認証・認可、画面、テストの順に小さく検証します。各層の責務を分けることで、障害の原因を特定しやすくし、仕様変更にも対応しやすくします。
