class Stage < ApplicationRecord
  belongs_to :segment
  has_many :answer_books
  has_many :activity_sequences
  has_many :learning_objectives

  validates :name, presence: true

  class << self

    def all_or_with_segment(segment_id = nil)
      return [] unless segment_id
      where(segment_id: segment_id)
    end
  end
end
