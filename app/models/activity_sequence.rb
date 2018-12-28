class ActivitySequence < ApplicationRecord
  include FriendlyId
  include ImageConcern
  include YearsEnum
  belongs_to :main_curricular_component, class_name: 'CurricularComponent'
  has_and_belongs_to_many :knowledge_matrices
  has_and_belongs_to_many :learning_objectives
  has_many :activities,
           -> { order 'activities.sequence' },
           dependent: :destroy
  has_many :collection_activity_sequences
  has_many :collections,
           through: :collection_activity_sequences
  has_many :activity_content_blocks, through: :activities

  enum status: { draft: 0, published: 1 }

  searchkick language: 'brazilian'

  validates :title, presence: true, uniqueness: true
  validates :presentation_text, presence: true
  validates :year, presence: true
  validates :status, presence: true
  validates :learning_objectives, presence: true
  validates :slug, presence: true, uniqueness: true

  friendly_id :title, use: %i[slugged finders]

  accepts_nested_attributes_for :activities, allow_destroy: true

  def should_generate_new_friendly_id?
    title_changed? || super
  end

  def self.where_optional_params(params = {})
    all.all_or_with_year(params[:years])
       .all_or_with_main_curricular_component(params)
       .all_or_with_axes(params)
       .all_or_with_sustainable_development_goal(params)
       .all_or_with_knowledge_matrices(params)
       .all_or_with_learning_objectives(params)
       .all_or_with_activity_types(params).group('activity_sequences.id')
  end

  def search_data
    {
      main_curricular_component_name: main_curricular_component.name,
      title: title,
      activities_title: activities.map(&:title),
      keywords: keywords,
      presentation_text: presentation_text,
      activity_content_block_titles: activity_content_blocks.map(&:title).compact,
      activity_content_block_bodies: activity_content_blocks.map(&:body).compact,
      sustainable_development_goal_names: sustainable_development_goals.map(&:name),
      learning_objective_descriptions: learning_objectives.map(&:description)
    }
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

  def self.all_or_with_year(years = nil)
    return all unless years
    where(year: years)
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

  def self.all_or_with_activity_types(params = {})
    return all unless params[:activity_type_ids]
    joins(activities: :activity_types).where(
      activities: {
        activity_types: {
          id: params[:activity_type_ids]
        }
      }
    )
  end
end
