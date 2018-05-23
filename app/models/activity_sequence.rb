class ActivitySequence < ApplicationRecord
  belongs_to :main_curricular_component, class_name: "CurricularComponent"
  has_and_belongs_to_many :curricular_components

  has_one_attached :image

  validate :image?
  validate :image_valid?

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
end
