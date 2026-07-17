# 10. Ruby / Railsのデバッグ

## 学習目標

推測でコードを変更するのではなく、再現、観測、仮説、検証を繰り返して原因を特定します。エラーメッセージ、スタックトレース、ログ、デバッガ、SQLを証拠として使えることを目指します。

## 障害を分類する

- SyntaxError: 構文解析できない
- NameError / NoMethodError: 名前や受信オブジェクトが想定と違う
- ActiveRecordの検証エラー: 業務ルールを満たさない
- RoutingError: メソッドとパスに対応するrouteがない
- Templateエラー: View評価中の問題
- DBエラー: 制約違反、接続失敗、migration不整合
- 性能障害: N+1、無制限取得、ロック待ち

分類すると、最初に調べる層を絞れます。

## 再現と最小化

発生日時、環境、ユーザー、入力、期待結果、実際の結果を記録します。毎回起きるか、特定データだけか、直前の変更と相関があるかを確認します。大きな画面操作を、request、モデル呼び出し、最小のRuby式へ徐々に縮めます。再現できないまま「直ったように見える」変更を入れないでください。

## スタックトレースとログ

スタックトレースは最上段だけでなく、自分のアプリケーションコードが最初に現れる箇所と例外発生までの呼び出しを読みます。Railsログではrequest ID、parameters、status、SQL、処理時間を関連付けます。パスワード、token、Cookie、個人情報はfilter parametersで伏せます。

```ruby
Rails.logger.info(
  event: "post_publish_failed",
  post_id: post.id,
  user_id: current_user.id,
  errors: post.errors.full_messages
)
```

構造化された文脈は役立ちますが、例外をログだけ残して成功扱いにしてはいけません。

## デバッガとconsole

`debug` gemの`binding.break`で停止し、変数、受信オブジェクト、条件を確認します。`bin/rails console --sandbox`は終了時にDB変更をrollbackするため調査に便利ですが、外部送信などDB外の副作用は戻りません。本番consoleでの変更は監査と手順なしに行わないでください。

## 仮説検証

「nilだから」では不十分です。「Controllerが対象Postを取得していないため`@post`がnil」という検証可能な仮説にします。一度に一要因だけ変え、修正前に失敗するテストを作り、修正後に通ることと関連テストが退行しないことを確認します。

## Railsでの典型例

- Strong Parametersで属性が許可されず保存されない
- developmentだけmigration済みでtest DBが古い
- associationの向きやforeign key名が違う
- validation失敗を`save`の戻り値確認なしで無視する
- Viewで未取得のインスタンス変数を参照する
- eager loading不足によるN+1

## Instagramクローンへの応用

「特定ユーザーのフィードだけ空」の場合、Followデータ、query条件、認可scope、pagination cursorを順に確認します。「画像だけ表示されない」場合はattachment、保存先、URL生成、HTTP応答、ブラウザ側エラーへ境界を分けます。

## 演習と確認

1. 意図的にNoMethodErrorを起こし、スタックトレースから原因行を特定してください。
2. validation失敗を`save!`と`save`で比較してください。
3. N+1を発生させ、SQLログのクエリ数を記録してください。

- 再現条件を具体的に記録できる
- 例外種別とスタックトレースを読める
- 機密情報をログへ出さない
- 仮説を一つずつ検証できる
- バグ修正に回帰テストを追加できる
