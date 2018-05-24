class LearningObjective < ApplicationRecord
  include YearsEnum
  belongs_to :curricular_component
  has_and_belongs_to_many :sustainable_development_goals
  has_and_belongs_to_many :activity_sequences

  validates :year, presence: true
  validates :description, presence: true
  validates :curricular_component, presence: true
  validates :sustainable_development_goals, presence: true

  before_save :generate_code

  def generate_code
    return nil unless valid?
    year_prefix = LearningObjective.years[year].to_s.rjust(2, '0')
    c_initial = curricular_component.initials
    code_prefix = 'EF' + year_prefix + c_initial

    self.code = format("#{code_prefix}%.2d", next_sequential_code_number(code_prefix))
  end

  def next_sequential_code_number(code_prefix)
    learnig_objective = LearningObjective.where('code like ?', "%#{code_prefix}%").last
    learnig_objective.blank? ? 1 : (learnig_objective.code.last(2).to_i + 1)
  end

  def code_and_description
    "#{code} - #{description}"
  end
end
