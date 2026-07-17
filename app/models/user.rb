class User < ApplicationRecord
  has_secure_password

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  has_many :active_follows,
    class_name: "Follow",
    foreign_key: :follower_id,
    inverse_of: :follower,
    dependent: :destroy
  has_many :following, through: :active_follows, source: :followed

  has_many :passive_follows,
    class_name: "Follow",
    foreign_key: :followed_id,
    inverse_of: :followed,
    dependent: :destroy
  has_many :followers, through: :passive_follows, source: :follower

  normalizes :email, with: ->(email) { email.strip.downcase }
  normalizes :username, with: ->(username) { username.strip.downcase }

  validates :username,
    presence: true,
    length: { in: 3..30 },
    format: { with: /\A[a-z0-9_]+\z/ },
    uniqueness: { case_sensitive: false }
  validates :email,
    presence: true,
    format: { with: URI::MailTo::EMAIL_REGEXP },
    uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 8 }, if: -> { password.present? }
end
