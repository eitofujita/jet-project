require "rails_helper"

RSpec.describe "Comments", type: :request do
  it "認証済みユーザーがコメントできる" do
    user = create(:user)
    post_record = create(:post)
    sign_in(user)

    expect {
      post post_comments_path(post_record),
        params: { comment: { body: "こんにちは" } },
        headers: { "ACCEPT" => "text/vnd.turbo-stream.html" }
    }.to change(Comment, :count).by(1)
    expect(response.media_type).to eq("text/vnd.turbo-stream.html")
  end

  it "別ユーザーのコメントを削除できない" do
    comment = create(:comment)
    sign_in(create(:user))

    expect {
      delete post_comment_path(comment.post, comment)
    }.not_to change(Comment, :count)
  end
end
