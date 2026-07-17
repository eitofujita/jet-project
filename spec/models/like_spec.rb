require "rails_helper"

RSpec.describe Like, type: :model do
  it "同じユーザーによる同じ投稿への二重Likeを拒否する" do
    like = create(:like)
    duplicate = build(:like, user: like.user, post: like.post)

    expect(duplicate).not_to be_valid
  end

  it "異なる投稿へのLikeを許可する" do
    like = create(:like)

    expect(build(:like, user: like.user)).to be_valid
  end
end
