require "rails_helper"

RSpec.describe Follow, type: :model do
  it "別のユーザーをフォローできる" do
    expect(build(:follow)).to be_valid
  end

  it "自分自身をフォローできない" do
    user = create(:user)

    expect(build(:follow, follower: user, followed: user)).not_to be_valid
  end

  it "同じ組み合わせの重複を拒否する" do
    follow = create(:follow)
    duplicate = build(:follow, follower: follow.follower, followed: follow.followed)

    expect(duplicate).not_to be_valid
  end
end
