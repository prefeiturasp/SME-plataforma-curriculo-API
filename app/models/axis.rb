class Axis < ApplicationRecord
  include YearsEnum
  belongs_to :curricular_component

  validates :description, presence: true, uniqueness: true
  validates :year, presence: true
end
