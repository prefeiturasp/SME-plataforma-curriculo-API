class Goal < ApplicationRecord
  belongs_to :sustainable_development_goal

  validates :description, presence: true, uniqueness: true
end
