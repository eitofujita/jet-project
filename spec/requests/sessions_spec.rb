require "rails_helper"

RSpec.describe "Sessions", type: :request do
  it "正しい認証情報でログインする" do
    user = create(:user)

    sign_in(user)

    expect(response).to redirect_to(root_path)
  end

  it "誤ったパスワードを拒否する" do
    user = create(:user)

    sign_in(user, password: "incorrect")

    expect(response).to have_http_status(:unprocessable_content)
  end
end
