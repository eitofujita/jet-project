# 6. HTTPサーバー

## 学習目標

ブラウザとサーバーがHTTPリクエスト／レスポンスを交換する仕組みを理解します。URL、メソッド、ステータスコード、ヘッダー、Cookieを読み、Railsの背後で何が起きているか説明できることを目指します。

## リクエストとレスポンス

HTTPリクエストにはメソッド、パス、ヘッダー、必要に応じて本文があります。レスポンスにはステータスコード、ヘッダー、本文があります。HTTP自体は状態を保持しないため、ログイン状態はCookieに保存したセッション識別子などを使って関連付けます。

```text
POST /posts HTTP/1.1
Host: example.test
Content-Type: application/json
Authorization: Bearer ...

{"caption":"hello"}
```

```text
HTTP/1.1 201 Created
Content-Type: application/json
Location: /posts/42

{"id":42,"caption":"hello"}
```

## URLとHTTPメソッド

URLはscheme、host、port、path、query、fragmentなどから成ります。fragmentは通常サーバーへ送られません。

- `GET /posts`: 一覧取得。安全で冪等であるべき
- `POST /posts`: 新規作成。通常は非冪等
- `PATCH /posts/42`: 一部更新
- `DELETE /posts/42`: 削除

GETでデータを削除すると、リンク先読みやクローラーで意図せず実行される危険があります。意味に合うメソッドを使い、サーバー側でも認証・認可を行います。

## ステータスコード

- `200 OK`: 成功
- `201 Created`: リソース作成成功
- `204 No Content`: 本文なしの成功
- `302 Found` / `303 See Other`: リダイレクト
- `400 Bad Request`: 構文などが不正
- `401 Unauthorized`: 認証が必要
- `403 Forbidden`: 認証済みだが許可されない
- `404 Not Found`: リソースが存在しない
- `422 Unprocessable Content`: 形式は読めるが検証失敗
- `500 Internal Server Error`: サーバー内部障害

すべてを200で返すと、クライアントや監視が成否を判断できません。一方、内部例外の詳細を500レスポンスへ出すと情報漏えいになります。

## Rackで最小サーバーを理解する

```ruby
class App
  def call(env)
    request = Rack::Request.new(env)

    if request.get? && request.path == "/health"
      [200, { "content-type" => "text/plain" }, ["ok"]]
    else
      [404, { "content-type" => "text/plain" }, ["not found"]]
    end
  end
end

run App.new
```

Rackアプリは環境Hashを受け、ステータス、ヘッダーHash、本文を列挙できるオブジェクトの三要素を返します。RailsもRack上で動作し、ミドルウェア、ルーター、Controllerを経てレスポンスを作ります。

## Cookie、セッション、セキュリティ

Cookieには`Secure`、`HttpOnly`、`SameSite`属性を適切に設定します。Cookieベース認証では、攻撃サイトから操作させるCSRFへの対策が必要です。TLSを使わないHTTPでは通信内容が盗聴・改ざんされ得ます。CORSはブラウザの読み取り制限であり、認証やサーバー間アクセス制御の代わりではありません。

## Instagramクローンへの応用

投稿作成は`POST /posts`、編集は`PATCH /posts/:id`、削除は`DELETE /posts/:id`へ対応させます。画像はmultipart形式で送信します。未ログインはログイン画面へ誘導し、他人の投稿編集は403または存在を隠す404とするなど、一貫した方針を決めます。

## 演習

1. Rackで`GET /posts/:id`を実装し、存在時200、不存在時404を返してください。
2. `curl`でGETとPOSTを送り、送受信ヘッダーを確認してください。
3. 401、403、404の違いを、投稿編集を例に説明してください。

## 確認チェックリスト

- HTTPリクエストとレスポンスの構成を説明できる
- メソッドとステータスを意味に合わせて選べる
- HTTPが状態を持たないことを説明できる
- Rackの入出力契約を理解している
- Cookie、CSRF、TLS、CORSの役割を混同していない
