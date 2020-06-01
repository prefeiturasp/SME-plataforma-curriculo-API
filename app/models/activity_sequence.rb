class ActivitySequence < ApplicationRecord
  include FriendlyId
  include ImageConcern
  include ActivitySequenceSearchable
  belongs_to :main_curricular_component, class_name: 'CurricularComponent'
  belongs_to :stage
  belongs_to :segment
  belongs_to :year
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

  def self.where_optional_params(params = {})
    all.all_or_with_year(params[:year_id])
       .all_or_with_main_curricular_component(params)
       .all_or_with_axes(params)
       .all_or_with_sustainable_development_goal(params)
       .all_or_with_knowledge_matrices(params)
       .all_or_with_learning_objectives(params).group('activity_sequences.id')
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

  def self.all_or_with_year(year_id = nil)
    return all unless year_id

    where(year_id: year_id)
  end

  def self.all_or_with_main_curricular_component(params = {})
    return all unless params[:curricular_component_slugs]

    joins(:main_curricular_component).merge(
      CurricularComponent.where(
        slug: params[:curricular_component_slugs]
      )
    )
  end

  def self.all_or_with_axes(params = {})
    return all unless params[:axis_ids]

    joins(learning_objectives: :axes).where(
      learning_objectives: {
        axes: {
          id: params[:axis_ids]
        }
      }
    )
  end

  def self.all_or_with_sustainable_development_goal(params = {})
    return all unless params[:sustainable_development_goal_ids]

    joins(learning_objectives: :sustainable_development_goals).where(
      learning_objectives: {
        sustainable_development_goals: {
          id: params[:sustainable_development_goal_ids]
        }
      }
    )
  end

  def self.all_or_with_knowledge_matrices(params = {})
    return all unless params[:knowledge_matrix_ids]

    joins(:knowledge_matrices).where(
      knowledge_matrices: {
        id: params[:knowledge_matrix_ids]
      }
    )
  end

  def self.all_or_with_learning_objectives(params = {})
    return all unless params[:learning_objective_ids]

    joins(:learning_objectives).where(
      learning_objectives: {
        id: params[:learning_objective_ids]
      }
    )
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
end
