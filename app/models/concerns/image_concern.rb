module ImageConcern
  extend ActiveSupport::Concern

  included do
    has_one_attached :image

    before_destroy :purge_image

    validate :image?
    validate :image_valid?
  end

  private

  def image?
    return if image.attached?
    errors.add(:image, 'Please upload image.')
    image.purge_later
  end

  def image_valid?
    return false unless image.attached?
    return true if image.content_type.start_with? 'image/'
    image.purge_later
    errors.add(:image, 'needs to be only images')
  end

  def purge_image
    image.purge if image.attached?
  end
end
