class ActivityType < ApplicationRecord
  validates :name, presence: true, uniqueness: true
end
