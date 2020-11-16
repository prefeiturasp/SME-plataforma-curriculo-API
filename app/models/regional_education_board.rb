class RegionalEducationBoard < ApplicationRecord
  has_many :projects
  has_many :schools
end
