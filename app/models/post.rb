class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_one_attached :image

  validates :caption, length: { maximum: 2_200 }
  validate :acceptable_image

  scope :recent, -> { order(created_at: :desc, id: :desc) }

  private

  def acceptable_image
    unless image.attached?
      errors.add(:image, "を選択してください")
      return
    end

    unless image.content_type.in?(%w[image/jpeg image/png image/webp])
      errors.add(:image, "はJPEG、PNG、WebP形式を選択してください")
    end

    errors.add(:image, "は5MB以下にしてください") if image.byte_size > 5.megabytes
  end
end
