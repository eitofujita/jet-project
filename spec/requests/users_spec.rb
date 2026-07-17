require "rails_helper"

RSpec.describe "Users", type: :request do
  it "新しいアカウントを作成してログインする" do
    expect {
      post users_path, params: {
        user: {
          username: "new_user",
          email: "new@example.com",
          password: "password123",
          password_confirmation: "password123"
        }
      }
    }.to change(User, :count).by(1)

    expect(response).to redirect_to(root_path)
  end

  it "不正な登録内容を422で再表示する" do
    post users_path, params: { user: { username: "", email: "", password: "short" } }

    expect(response).to have_http_status(:unprocessable_content)
  end
end
