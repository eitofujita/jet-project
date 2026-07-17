FactoryBot.define do
  factory :user do
    sequence(:username) { |number| "user_#{number}" }
    sequence(:email) { |number| "user#{number}@example.com" }
    password { "password123" }
    password_confirmation { "password123" }
    admin { false }
  end
end
