FactoryBot.define do
  factory :comment do
    association :user
    association :post
    body { "テストコメント" }
  end
end
