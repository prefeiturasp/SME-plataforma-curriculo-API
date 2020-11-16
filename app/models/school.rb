class School < ApplicationRecord
  belongs_to :regional_education_board
  has_many :projects
end
