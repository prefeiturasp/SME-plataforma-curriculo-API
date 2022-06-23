class RegionalEducationBoard < ApplicationRecord
  has_many :projects
  has_many :schools
  has_and_belongs_to_many :users
end
