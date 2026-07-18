require "rails_helper"

RSpec.describe "Authentication", type: :system do
  before { driven_by(:rack_test) }

  it "登録してフィードを表示する" do
    visit signup_path

    fill_in "Имя пользователя", with: "system_user"
    fill_in "Электронная почта", with: "system@example.com"
    fill_in "Пароль (не менее 8 символов)", with: "password123"
    fill_in "Подтверждение пароля", with: "password123"
    click_button "Зарегистрироваться"

    expect(page).to have_content("Аккаунт создан")
    expect(page).to have_content("Лента")
  end
end
