class Stage < ApplicationRecord
  include SequenceConcern

  belongs_to :segment
  has_many :answer_books
  has_many :activity_sequences
  has_many :learning_objectives
  has_many :years
  has_and_belongs_to_many :projects

  validates :name, presence: true
  validates :sequence, presence: true

  after_save :activity_sequence_reindex

  class << self

    def all_or_with_segment(segment_id = nil)
      return [] unless segment_id
      where(segment_id: segment_id)
    end
  end

  private

  def activity_sequence_reindex
    ActivitySequence.reindex(async: true)
  end
end
