class KnowledgeMatrix < ApplicationRecord
  include SequenceConcern
  has_and_belongs_to_many :activity_sequences
  has_and_belongs_to_many :projects
  include DestroyValidator # has_and_belongs_to_many doesn't support dependent restrict_with_error
  before_destroy :check_associations

  validates :for_description, presence: true
  validates :know_description, presence: true
  validates :title, presence: true, uniqueness: true
  validates :sequence, presence: true

  def sequence_and_title
    "#{sequence} - #{title}"
  end

  private

  def check_associations(associations = %i[activity_sequences])
    super(associations)
  end
end
