require "rails_helper"

RSpec.describe "Posts", type: :request do
  it "未認証ユーザーをログイン画面へ送る" do
    get posts_path

    expect(response).to redirect_to(new_session_path)
  end

  it "所有者が投稿を更新できる" do
    post_record = create(:post)
    sign_in(post_record.user)

    patch post_path(post_record), params: { post: { caption: "更新後" } }

    expect(response).to redirect_to(post_path(post_record))
    expect(post_record.reload.caption).to eq("更新後")
  end

  it "別ユーザーは投稿を更新できない" do
    post_record = create(:post, caption: "元の本文")
    sign_in(create(:user))

    patch post_path(post_record), params: { post: { caption: "改ざん" } }

    expect(post_record.reload.caption).to eq("元の本文")
  end
end
