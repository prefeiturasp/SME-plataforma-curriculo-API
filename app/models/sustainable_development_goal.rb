class SustainableDevelopmentGoal < ApplicationRecord
  has_and_belongs_to_many :activity_sequences
  has_and_belongs_to_many :learning_objectives
  has_many :goals, dependent: :destroy
  has_one_attached :icon

  validates :sequence, presence: true, uniqueness: true
  validates :name, presence: true, uniqueness: true
  validates :description, presence: true

  validate :icon?
  validate :icon_valid?

  accepts_nested_attributes_for :goals, allow_destroy: true

  def sequence_and_name
    "#{sequence} - #{name}"
  end

  def icon?
    return if icon.attached?
    errors.add(:icon, 'Please upload icon.')
    icon.purge_later
  end

  def icon_valid?
    return false unless icon.attached?
    return true if icon.content_type.start_with? 'image/'
    icon.purge_later
    errors.add(:icon, 'needs to be only images')
  end
end
