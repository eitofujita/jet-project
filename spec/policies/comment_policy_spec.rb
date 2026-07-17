require "rails_helper"

RSpec.describe CommentPolicy do
  it "作成者の削除を許可する" do
    comment = create(:comment)

    expect(described_class.new(comment.user, comment).destroy?).to be(true)
  end

  it "別ユーザーの削除を拒否する" do
    comment = create(:comment)

    expect(described_class.new(create(:user), comment).destroy?).to be(false)
  end
end
