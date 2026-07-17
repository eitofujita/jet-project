require "rails_helper"

RSpec.describe User, type: :model do
  it "有効な属性で保存できる" do
    expect(build(:user)).to be_valid
  end

  it "メールアドレスとユーザー名を正規化する" do
    user = create(:user, email: " Mina@Example.COM ", username: " Mina_1 ")

    expect(user.email).to eq("mina@example.com")
    expect(user.username).to eq("mina_1")
  end

  it "8文字未満のパスワードを拒否する" do
    user = build(:user, password: "short", password_confirmation: "short")

    expect(user).not_to be_valid
  end
end
