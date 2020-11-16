class Project < ApplicationRecord
  belongs_to :teacher
  belongs_to :regional_education_board
  belongs_to :school
  has_and_belongs_to_many :segments
  has_and_belongs_to_many :stages
  has_and_belongs_to_many :years
  has_and_belongs_to_many :areas
  has_and_belongs_to_many :advisors
  has_and_belongs_to_many :curriculum_subjects
  has_and_belongs_to_many :tags
  has_and_belongs_to_many :participants
  has_and_belongs_to_many :curricular_components
  has_and_belongs_to_many :learning_objectives
  has_and_belongs_to_many :knowledge_matrices
  has_and_belongs_to_many :student_protagonisms
  has_many :sustainable_development_goals, through: :learning_objectives
  has_many :axes, through: :learning_objectives
  has_many :project_links, dependent: :destroy
  accepts_nested_attributes_for :project_links, allow_destroy: true

  has_one_attached :cover_image
end
