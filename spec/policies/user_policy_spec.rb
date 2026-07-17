require "rails_helper"

RSpec.describe UserPolicy do
  it "別ユーザーのフォローを許可する" do
    user = create(:user)
    target = create(:user)

    expect(described_class.new(user, target).follow?).to be(true)
  end

  it "自分自身のフォローを拒否する" do
    user = create(:user)

    expect(described_class.new(user, user).follow?).to be(false)
  end
end
