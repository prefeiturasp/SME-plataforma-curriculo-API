class ActivitySequence < ApplicationRecord
  include FriendlyId
  include ImageConcern
  include YearsEnum
  include ActivitySequenceSearchable
  belongs_to :main_curricular_component, class_name: 'CurricularComponent'
  belongs_to :stage
  belongs_to :segment
  has_and_belongs_to_many :knowledge_matrices
  has_and_belongs_to_many :learning_objectives
  has_many :activities,
           -> { order 'activities.sequence' },
           dependent: :destroy
  has_many :collection_activity_sequences
  has_many :collections,
           through: :collection_activity_sequences
  has_many :activity_content_blocks, through: :activities
  has_many :axes, through: :learning_objectives
  has_many :sustainable_development_goals, through: :learning_objectives
  has_many :performeds, class_name: 'ActivitySequencePerformed'
  has_many :activity_sequence_ratings, through: :performeds

  enum status: { draft: 0, published: 1 }

  validates :title, presence: true, uniqueness: true
  validates :presentation_text, presence: true
  validates :year, presence: true
  validates :status, presence: true
  validates :learning_objectives, presence: true
  validates :slug, presence: true, uniqueness: true

  friendly_id :title, use: %i[slugged finders]

  scope :evaluateds, -> {
                       includes(:performeds)
                         .where(activity_sequence_performeds: { evaluated: true })
                     }

  accepts_nested_attributes_for :activities, allow_destroy: true

  def should_generate_new_friendly_id?
    title_changed? || super
  end

  def curricular_components
    CurricularComponent.joins(activities: :activity_sequence)
                       .where(
                         activities: {
                           activity_sequence_id: id
                         }
                       ).group('curricular_components.id')
  end

  def sustainable_development_goals
    SustainableDevelopmentGoal.joins(:learning_objectives)
                              .where(
                                learning_objectives: {
                                  id: learning_objective_ids
                                }
                              ).group('sustainable_development_goals.id')
  end

  def self.where_id_with_includes(activity_sequence_ids)
    id_indices = Hash[activity_sequence_ids.map.with_index { |id, idx| [id, idx] }]
    ActivitySequence.where(id: activity_sequence_ids)
                    .includes(:main_curricular_component)
                    .includes(:stage)
                    .includes(:segment)
                    .includes(learning_objectives: :axes)
                    .includes(learning_objectives: :curricular_component)
                    .includes(learning_objectives: :sustainable_development_goals)
                    .includes(:knowledge_matrices)
                    .includes(:learning_objectives)
                    .sort_by { |a| id_indices[a.id.to_s] }
  end

  def performed_by_teacher(teacher)
    performeds.by_teacher(teacher).last
  end

  def already_performed_by_teacher?(teacher)
    performed_by_teacher(teacher).present?
  end

  def already_evaluated_by_teacher?(teacher)
    return false unless performed_by_teacher(teacher).present?

    performed_by_teacher(teacher).evaluated?
  end

  def already_saved_in_collection?(teacher)
    collections.where(teacher_id: teacher.id).present?
  end

  def average_by_rating_type(rating_id)
    activity_sequence_ratings.where(rating_id: rating_id).pluck(:score).mean
  end

  def total_evaluations
    performeds.where(evaluated: true).count
  end

  private

  def year_reference_on_database
    key = year_before_type_cast
    return key if key.is_a? Integer

    ActivitySequence.years[key]
  end
end
