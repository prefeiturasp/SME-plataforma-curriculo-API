class Collection < ApplicationRecord
  belongs_to :teacher
  has_many :collection_activity_sequences, dependent: :destroy
  has_many :activity_sequences,
           -> { order 'collection_activity_sequences.sequence ASC' },
           through: :collection_activity_sequences

  has_many :collection_projects, dependent: :destroy
  has_many :projects,
           -> { order 'collection_projects.sequence ASC' },
           through: :collection_projects

  validates :name, presence: true, length: { maximum: 30 }

  accepts_nested_attributes_for :collection_activity_sequences, allow_destroy: true
  accepts_nested_attributes_for :collection_projects, allow_destroy: true

  def number_of_published_activity_sequences
    activity_sequences.published.count
  end

  def number_of_projects
    projects.count
  end

  # TODO: change when inserting classes that come from SME
  def number_of_classes
    ''
  end
end
