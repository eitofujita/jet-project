require "base64"
require "stringio"

FactoryBot.define do
  factory :post do
    association :user
    caption { "テスト投稿" }

    after(:build) do |post|
      next if post.image.attached?

      png = Base64.decode64(
        "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNk+A8AAQUBAScY42YAAAAASUVORK5CYII="
      )
      post.image.attach(
        io: StringIO.new(png),
        filename: "test.png",
        content_type: "image/png"
      )
    end
  end
end
