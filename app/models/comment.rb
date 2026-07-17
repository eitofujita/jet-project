class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post

  validates :body, presence: true, length: { maximum: 500 }

  scope :oldest_first, -> { order(created_at: :asc, id: :asc) }
end
