class SustainableDevelopmentGoal < ApplicationRecord
  has_one_attached :icon

  validates :sequence, presence: true, uniqueness: true
  validates :name, presence: true, uniqueness: true
  validates :description, presence: true
  validates :goals, presence: true

  validate :icon?
  validate :icon_valid?

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

  def goals_raw
    goals.split(';').join('<br />').html_safe if goals.present?
  end
end
