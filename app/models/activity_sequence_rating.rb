class ActivitySequenceRating < ApplicationRecord
  belongs_to :activity_sequence_performed
  belongs_to :rating

  validates :activity_sequence_performed, uniqueness: true
end
