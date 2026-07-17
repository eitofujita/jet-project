require "rails_helper"

RSpec.describe Post, type: :model do
  it "画像があれば保存できる" do
    expect(build(:post)).to be_valid
  end

  it "画像がなければ保存できない" do
    post = build(:post)
    post.image.detach

    expect(post).not_to be_valid
    expect(post.errors[:image]).to be_present
  end

  it "2,200文字を超えるcaptionを拒否する" do
    expect(build(:post, caption: "a" * 2_201)).not_to be_valid
  end
end
