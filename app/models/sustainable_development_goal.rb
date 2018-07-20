class SustainableDevelopmentGoal < ApplicationRecord
  include SequenceConcern
  has_and_belongs_to_many :learning_objectives
  has_many :goals, dependent: :restrict_with_error
  has_one_attached :icon
  has_one_attached :sub_icon

  validates :name, presence: true, uniqueness: true
  validates :description, presence: true
  validates :color, presence: true, uniqueness: true

  validate :icon?
  validate :icon_valid?
  validate :sub_icon?
  validate :sub_icon_valid?

  default_scope -> { order('sequence') }

  accepts_nested_attributes_for :goals, allow_destroy: true

  def sequence_and_name
    "#{sequence} - #{name}"
  end

  def icon?
    return if icon.attached?
    errors.add(:icon, 'Please upload icon.')
    icon.purge_later
  end

  def sub_icon?
    return if sub_icon.attached?
    errors.add(:sub_icon, 'Please upload sub icon.')
    sub_icon.purge_later
  end

  def icon_valid?
    return false unless icon.attached?
    return true if icon.content_type.start_with? 'image/'
    icon.purge_later
    errors.add(:icon, 'needs to be only images')
  end

  def sub_icon_valid?
    return false unless sub_icon.attached?
    return true if sub_icon.content_type.start_with? 'image/'
    sub_icon.purge_later
    errors.add(:sub_icon, 'needs to be only images')
  end
end
