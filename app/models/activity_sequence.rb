class ActivitySequence < ApplicationRecord
  include YearsEnum
  belongs_to :main_curricular_component, class_name: 'CurricularComponent'
  has_and_belongs_to_many :curricular_components
  has_and_belongs_to_many :sustainable_development_goals
  has_and_belongs_to_many :knowledge_matrices
  has_and_belongs_to_many :learning_objectives

  has_one_attached :image

  enum status: { draft: 0, published: 1 }

  validates :title, presence: true, uniqueness: true
  validates :presentation_text, presence: true
  validates :books, presence: true
  validates :estimated_time, presence: true
  validates :year, presence: true
  validates :status, presence: true

  validate :image?
  validate :image_valid?

  before_destroy :purge_image

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

  private

  def purge_image
    image.purge if image.attached?
  end
end
