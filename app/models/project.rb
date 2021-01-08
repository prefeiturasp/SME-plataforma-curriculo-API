class Project < ApplicationRecord
  include ProjectSearchable
  include FriendlyId

  belongs_to :teacher, optional: true
  belongs_to :regional_education_board, optional: true
  belongs_to :school, optional: true
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
  has_many :comments, dependent: :destroy
  accepts_nested_attributes_for :project_links, allow_destroy: true
  has_one_attached :cover_image
  has_many :collection_projects, dependent: :destroy
  has_many :collections,
           through: :collection_projects


  validates :title, presence: true, uniqueness: true
  validates :slug, presence: true, uniqueness: true

  friendly_id :title, use: %i[slugged finders]

  def should_generate_new_friendly_id?
    title_changed? || super
  end

  def already_saved_in_collection?(teacher)
    collections.where(teacher_id: teacher.id).present?
  end

  def self.where_id_with_includes(project_ids)
    id_indices = Hash[project_ids.map.with_index { |id, idx| [id, idx] }]
    Project.where(id: project_ids)
                    .includes(:segments)
                    .includes(:stages)
                    .includes(:years)
                    .includes(:curricular_components)
                    .includes(:knowledge_matrices)
                    .includes(:student_protagonisms)
                    .includes(:learning_objectives)
                    .includes(:regional_education_board)
                    .includes(:school)
                    .includes(:axes)
                    .includes(:sustainable_development_goals)
                    .sort_by { |a| id_indices[a.id.to_s] }
  end
end
