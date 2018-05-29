class ActivitySequence < ApplicationRecord
  include YearsEnum
  belongs_to :main_curricular_component, class_name: 'CurricularComponent'
  has_and_belongs_to_many :curricular_components
  has_and_belongs_to_many :sustainable_development_goals
  has_and_belongs_to_many :knowledge_matrices
  has_and_belongs_to_many :learning_objectives
  has_many :activities, -> { order 'sequence' }

  enum status: { draft: 0, published: 1 }

  validates :title, presence: true, uniqueness: true
  validates :presentation_text, presence: true
  validates :books, presence: true
  validates :estimated_time, presence: true
  validates :year, presence: true
  validates :status, presence: true

  accepts_nested_attributes_for :activities, allow_destroy: true

  include ImageConcern
end
