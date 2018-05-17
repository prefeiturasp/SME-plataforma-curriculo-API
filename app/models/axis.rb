class Axis < ApplicationRecord
  belongs_to :curricular_component

  validates :description, presence: true, uniqueness: true
end
