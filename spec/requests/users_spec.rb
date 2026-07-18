require "rails_helper"

RSpec.describe "Users", type: :request do
  it "ほかのユーザーを一覧表示する" do
    current_user = create(:user, username: "current_user")
    other_user = create(:user, username: "other_user")
    sign_in(current_user)

    get users_path

    expect(response).to have_http_status(:success)
    expect(response.body).to include("@#{other_user.username}")
    expect(user_path(other_user)).to eq("/users/@other_user")

    get user_path(other_user)
    expect(response).to have_http_status(:success)
  end

  it "フォロワーとフォロー中の一覧を表示する" do
    viewer = create(:user)
    user = create(:user, username: "profile_user")
    follower = create(:user, username: "follower_user")
    followed = create(:user, username: "followed_user")
    create(:follow, follower: follower, followed: user)
    create(:follow, follower: user, followed: followed)
    sign_in(viewer)

    get followers_user_path(user)
    expect(response).to have_http_status(:success)
    expect(response.body).to include("@follower_user")
    expect(response.body).not_to include("@followed_user")

    get following_user_path(user)
    expect(response).to have_http_status(:success)
    expect(response.body).to include("@followed_user")
    expect(response.body).not_to include("@follower_user")
  end

  it "新しいアカウントを作成してログインする" do
    expect {
      post signup_path, params: {
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
    post signup_path, params: { user: { username: "", email: "", password: "short" } }

    expect(response).to have_http_status(:unprocessable_content)
  end
end
