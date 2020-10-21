class Project < ApplicationRecord
  has_and_belongs_to_many :areas
  has_and_belongs_to_many :advisors
  has_and_belongs_to_many :curriculum_subjects
  has_and_belongs_to_many :tags
  has_and_belongs_to_many :participants
end
