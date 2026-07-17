require "rails_helper"

RSpec.describe Comment, type: :model do
  it "本文があれば保存できる" do
    expect(build(:comment)).to be_valid
  end

  it "空の本文を拒否する" do
    expect(build(:comment, body: "")).not_to be_valid
  end

  it "500文字を超える本文を拒否する" do
    expect(build(:comment, body: "a" * 501)).not_to be_valid
  end
end
