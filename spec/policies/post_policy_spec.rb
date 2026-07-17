require "rails_helper"

RSpec.describe PostPolicy do
  it "所有者の更新を許可する" do
    post = create(:post)

    expect(described_class.new(post.user, post).update?).to be(true)
  end

  it "別ユーザーの更新を拒否する" do
    post = create(:post)

    expect(described_class.new(create(:user), post).update?).to be(false)
  end
end
