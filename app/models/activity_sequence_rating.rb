class ActivitySequenceRating < ApplicationRecord
  belongs_to :activity_sequence_performed
  belongs_to :rating

  validates :activity_sequence_performed, uniqueness: { scope: :rating,
                                                        message: 'should happen once per rating' }
  validates :score, numericality: { only_integer: true,
                                    greater_than_or_equal_to: 0,
                                    less_than_or_equal_to: 5 }
end
