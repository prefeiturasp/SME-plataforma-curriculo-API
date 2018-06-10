class ActivitySequence < ApplicationRecord
  include FriendlyId
  include ImageConcern
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
  validates :estimated_time, presence: true
  validates :year, presence: true
  validates :status, presence: true
  validates :learning_objectives, presence: true
  validates :slug, presence: true, uniqueness: true

  friendly_id :title, use: :slugged

  accepts_nested_attributes_for :activities, allow_destroy: true

  def should_generate_new_friendly_id?
    title_changed? || super
  end

  def self.where_optional_params(params = {})
    all.all_or_with_year(params[:year])
       .all_or_with_curricular_component(params)
       .all_or_with_axes(params)
       .all_or_with_sustainable_development_goal(params)
       .all_or_with_knowledge_matrices(params)
       .all_or_with_learning_objectives(params)
       .all_or_with_activity_types(params)
  end

  # TODO
  def self.initialize_query(params); end

  def self.all_or_with_year(year = nil)
    return all unless year
    where(year: year)
  end

  def self.all_or_with_curricular_component(params = {})
    return all unless params[:curricular_component_friendly_id]
    joins(:curricular_components).where(
      curricular_components: {
        slug: params[:curricular_component_friendly_id]
      }
    )
  end

  def self.all_or_with_axes(params = {})
    return all unless params[:axis_id]
    joins(curricular_components: :axes).where(
      curricular_components: {
        axes: {
          id: params[:axis_id],
          year: params[:year]
        }
      }
    )
  end

  def self.all_or_with_sustainable_development_goal(params = {})
    return all unless params[:sustainable_development_goal_id]
    joins(:sustainable_development_goals).where(
      sustainable_development_goals: {
        id: params[:sustainable_development_goal_id]
      }
    )
  end

  def self.all_or_with_knowledge_matrices(params = {})
    return all unless params[:knowledge_matrix_id]
    joins(:knowledge_matrices).where(
      knowledge_matrices: {
        id: params[:knowledge_matrix_id]
      }
    )
  end

  def self.all_or_with_learning_objectives(params = {})
    return all unless params[:learning_objective_id]
    joins(:learning_objectives).where(
      learning_objectives: {
        id: params[:learning_objective_id]
      }
    )
  end

  def self.all_or_with_activity_types(params = {})
    return all unless params[:activity_type_id]
    joins(activities: :activity_types).where(
      activities: {
        activity_types: {
          id: params[:activity_type_id]
        }
      }
    )
  end
end
