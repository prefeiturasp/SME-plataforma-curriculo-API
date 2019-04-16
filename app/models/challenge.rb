class Challenge < ApplicationRecord
  include FriendlyId
  include ImageConcern

  has_and_belongs_to_many :learning_objectives
  has_and_belongs_to_many :curricular_components
  has_and_belongs_to_many :knowledge_matrices

  has_many :axes, through: :learning_objectives
  has_many :challenge_content_blocks, dependent: :destroy

  enum category: { project: 0, make_and_remake: 1, games_and_investigation: 2 }
  enum status: { draft: 0, published: 1 }

  validates :title, presence: true, uniqueness: true
  validates :finish_at, presence: true
  validates :category, presence: true
  validates :learning_objectives, presence: true
  validates :slug, presence: true, uniqueness: true

  friendly_id :title, use: %i[slugged finders]

  accepts_nested_attributes_for :challenge_content_blocks, allow_destroy: true
end
