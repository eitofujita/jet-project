require "rails_helper"

RSpec.describe "Likes", type: :request do
  it "Likeと解除を実行できる" do
    user = create(:user)
    post_record = create(:post)
    sign_in(user)

    expect {
      post post_like_path(post_record), headers: { "ACCEPT" => "text/vnd.turbo-stream.html" }
    }.to change(Like, :count).by(1)
    expect(response.media_type).to eq("text/vnd.turbo-stream.html")

    expect {
      delete post_like_path(post_record), headers: { "ACCEPT" => "text/vnd.turbo-stream.html" }
    }.to change(Like, :count).by(-1)
    expect(response.media_type).to eq("text/vnd.turbo-stream.html")
  end

  it "同じ投稿へのLikeを重複作成しない" do
    like = create(:like)
    sign_in(like.user)

    expect {
      post post_like_path(like.post)
    }.not_to change(Like, :count)
  end
end
