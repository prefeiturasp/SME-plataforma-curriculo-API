class LearningObjective < ApplicationRecord
  belongs_to :curricular_component
  belongs_to :segment
  belongs_to :stage
  belongs_to :year
  has_and_belongs_to_many :sustainable_development_goals
  has_and_belongs_to_many :activity_sequences
  has_and_belongs_to_many :activities
  has_and_belongs_to_many :axes

  include DestroyValidator # has_and_belongs_to_many doesn't support dependent restrict_with_error

  validates :description, presence: true
  validates :curricular_component, presence: true
  validates :code, presence: true, uniqueness: true

  default_scope { order(code: :asc) }

  after_save :activity_sequence_reindex

  def code_and_description
    "#{code} - #{description}"
  end

  def self.all_or_with_stage(stage_id = nil)
    return all unless stage_id
    where(stage_id: stage_id)
  end
  
  def self.all_or_with_year(year = nil)
    return all unless year
    where(year_id: year)
  end

  def self.all_or_with_curricular_component(curricular_component_slug = nil)
    return all unless curricular_component_slug
    joins(:curricular_component).where(
      curricular_components: {
        slug: curricular_component_slug
      }
    )
  end

  def code=(value)
    super(value.to_s.upcase)
  end

  private

  def check_associations(associations = %i[activity_sequences
                                           curricular_component
                                           sustainable_development_goals
                                           activities])
    super(associations)
  end

  def activity_sequence_reindex
    activity_sequences.each(&:reindex)
  end
end
