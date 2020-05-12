class Stage < ApplicationRecord
  belongs_to :segment
  has_many :answer_book
  has_many :activity_sequence
  has_many :learning_objective

  validates :name, presence: true

  class << self

    def all_or_with_segment(segment_id)
      return [] unless segment_id
      Stage.where(segment_id: segment_id)
    end
  end
end
