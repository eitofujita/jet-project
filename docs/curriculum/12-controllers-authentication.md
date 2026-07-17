# 12. Controllerと認証

## 学習目標

RESTfulなControllerを設計し、入力の許可、セッション、パスワードハッシュを用いて安全な認証を実装します。認証と認可を混同せず、ControllerをHTTP境界として保つことを目指します。

## Controllerの責務

```ruby
class PostsController < ApplicationController
  before_action :require_authentication
  before_action :set_post, only: %i[show edit update destroy]

  def create
    post = current_user.posts.build(post_params)
    if post.save
      redirect_to post, notice: "投稿しました", status: :see_other
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def post_params
    params.require(:post).permit(:caption, :image)
  end
end
```

Controllerはrequestを解釈し、認証・認可後に処理を呼び、適切なstatusとresponseを返します。複数モデルの複雑な更新はサービスへ分離します。

## Strong Parameters

フォームから届く値をそのまま`update(params[:post])`へ渡すと、`user_id`や管理属性まで改ざんされ得ます。許可する属性を操作ごとに明示します。ただしStrong Parametersは型・長さ・業務ルールを保証しないため、モデルvalidationとDB制約も必要です。

## パスワード

パスワードを平文や復号可能な暗号で保存してはいけません。`has_secure_password`とbcryptなど、パスワード向けの遅いハッシュを使います。

```ruby
class User < ApplicationRecord
  has_secure_password
  normalizes :email, with: ->(email) { email.strip.downcase }
end
```

ログイン失敗時に「メールは存在するがパスワードが違う」と区別するとアカウント列挙を助けるため、外部表示は一般化します。総当たり対策としてrate limitやロック方針を検討します。

## セッション

認証成功後、推測困難なセッションIDまたは署名・暗号化されたCookieを使います。CookieにはSecure、HttpOnly、SameSiteを設定し、ログイン時や権限変更時はsession fixationを防ぐためセッションを再生成します。ログアウトではサーバー側状態とCookieを無効化します。

```ruby
def create
  user = User.find_by(email: params[:email].to_s.strip.downcase)
  if user&.authenticate(params[:password])
    reset_session
    session[:user_id] = user.id
    redirect_to root_path
  else
    flash.now[:alert] = "メールアドレスまたはパスワードが正しくありません"
    render :new, status: :unprocessable_entity
  end
end
```

## CSRFとリダイレクト

Cookie認証では、第三者サイトから利用者の権限でPOSTさせるCSRFを防ぐ必要があります。RailsのCSRF保護を理由なく無効化しません。保存成功後はPOST再送信を避けるためredirectし、失敗時は入力とerrorsを保持してrenderします。

## Instagramクローンへの応用

新規登録、ログイン、ログアウトを最初に完成させ、`current_user`と認証filterを共通化します。投稿者IDはフォームから受け取らず、必ず`current_user.posts.build`で関連付けます。

## 演習と確認

1. 登録・ログイン・ログアウトのrouteとstatusを設計してください。
2. `user_id`改ざんを再現し、関連経由の構築で防いでください。
3. 未認証で保護ページへアクセスするrequest specを書いてください。

- Controllerの責務をHTTP境界に限定できる
- Strong Parametersの目的と限界を説明できる
- パスワードハッシュを使う理由を説明できる
- session fixation、CSRF、総当たりへの対策を理解している
- 認証と認可を区別できる
