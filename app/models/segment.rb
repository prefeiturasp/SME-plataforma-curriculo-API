class Segment < ApplicationRecord
  include SequenceConcern

  has_many :stages
  has_many :answer_books
  has_many :years
  has_many :activity_sequences
  has_many :learning_objectives
  has_many :public_consultation
  has_and_belongs_to_many :projects

  validates :name, presence: true
  validates :color, presence: true
  validates :sequence, presence: true

  after_save :activity_sequence_reindex

  private

  def activity_sequence_reindex
    ActivitySequence.reindex(async: true)
  end
end
