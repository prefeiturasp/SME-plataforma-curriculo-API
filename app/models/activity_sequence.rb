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
  validates :estimated_time, presence: true
  validates :year, presence: true
  validates :status, presence: true
  validates :learning_objectives, presence: true

  accepts_nested_attributes_for :activities, allow_destroy: true

  include ImageConcern

  def self.where_optional_params(params)
    all.build_query_year(params)
       .build_query_curricular_component(params)
       .build_query_axes(params)
       .build_query_sustainable_development_goal(params)
       .build_query_knowledge_matrices(params)
       .build_query_learning_objectives(params)
       .build_query_activity_types(params)
  end

  # TODO
  def self.initialize_query(params); end

  def self.build_query_year(params)
    return all unless params[:year]
    where(year: params[:year])
  end

  def self.build_query_curricular_component(params)
    return all unless params[:curricular_component_friendly_id]
    joins(:curricular_components).where(
      curricular_components: {
        slug: params[:curricular_component_friendly_id]
      }
    )
  end

  def self.build_query_axes(params)
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

  def self.build_query_sustainable_development_goal(params)
    return all unless params[:sustainable_development_goal_id]
    joins(:sustainable_development_goals).where(
      sustainable_development_goals: {
        id: params[:sustainable_development_goal_id]
      }
    )
  end

  def self.build_query_knowledge_matrices(params)
    return all unless params[:knowledge_matrix_id]
    joins(:knowledge_matrices).where(
      knowledge_matrices: {
        id: params[:knowledge_matrix_id]
      }
    )
  end

  def self.build_query_learning_objectives(params)
    return all unless params[:learning_objective_id]
    joins(:learning_objectives).where(
      learning_objectives: {
        id: params[:learning_objective_id]
      }
    )
  end

  def self.build_query_activity_types(params)
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
