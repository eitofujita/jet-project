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
      errors.add(:image, "необходимо выбрать")
      return
    end

    unless image.content_type.in?(%w[image/jpeg image/png image/webp])
      errors.add(:image, "должно быть в формате JPEG, PNG или WebP")
    end

    errors.add(:image, "должно быть не больше 5 МБ") if image.byte_size > 5.megabytes
  end
end
