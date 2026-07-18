require "rails_helper"

RSpec.describe "Posts", type: :request do
  it "未認証ユーザーをログイン画面へ送る" do
    get posts_path

    expect(response).to redirect_to(login_path)
  end

  it "画像選択欄をロシア語で表示する" do
    sign_in(create(:user))

    get new_post_path

    expect(response).to have_http_status(:success)
    expect(response.body).to include("Выбрать файл")
    expect(response.body).to include("Файл не выбран")
  end

  it "投稿一覧から個別投稿へ移動できるリンクを表示する" do
    post_record = create(:post)
    sign_in(create(:user))

    get posts_path

    expect(response).to have_http_status(:success)
    expect(response.body).to include(post_path(post_record))
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
