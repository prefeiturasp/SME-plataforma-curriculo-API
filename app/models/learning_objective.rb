class LearningObjective < ApplicationRecord
  include YearsEnum
  belongs_to :curricular_component
  has_and_belongs_to_many :sustainable_development_goals
  has_and_belongs_to_many :activity_sequences

  validates :year, presence: true
  validates :description, presence: true
  validates :curricular_component, presence: true
  validates :sustainable_development_goals, presence: true
  validates :code, presence: true

  def code_and_description
    "#{code} - #{description}"
  end
end
