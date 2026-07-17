require "rails_helper"

RSpec.describe "Follows", type: :request do
  it "フォローと解除を実行できる" do
    user = create(:user)
    target = create(:user)
    sign_in(user)

    expect {
      post user_follow_path(target)
    }.to change(Follow, :count).by(1)

    expect {
      delete user_follow_path(target)
    }.to change(Follow, :count).by(-1)
  end

  it "自分自身をフォローできない" do
    user = create(:user)
    sign_in(user)

    expect {
      post user_follow_path(user)
    }.not_to change(Follow, :count)
  end
end
