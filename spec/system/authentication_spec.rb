require "rails_helper"

RSpec.describe "Authentication", type: :system do
  before { driven_by(:rack_test) }

  it "登録してフィードを表示する" do
    visit new_user_path

    fill_in "ユーザー名", with: "system_user"
    fill_in "メールアドレス", with: "system@example.com"
    fill_in "パスワード（8文字以上）", with: "password123"
    fill_in "パスワード確認", with: "password123"
    click_button "登録する"

    expect(page).to have_content("アカウントを作成しました")
    expect(page).to have_content("フィード")
  end
end
