require "rails_helper"

RSpec.describe "Feeds", type: :request do
  it "フォロー中のユーザーの投稿を表示する" do
    user = create(:user)
    followed = create(:user)
    create(:follow, follower: user, followed: followed)
    visible_post = create(:post, user: followed, caption: "表示対象")
    create(:post, caption: "表示対象外")
    sign_in(user)

    get root_path

    expect(response).to have_http_status(:success)
    expect(response.body).to include(visible_post.caption)
    expect(response.body).not_to include("表示対象外")
  end
end
