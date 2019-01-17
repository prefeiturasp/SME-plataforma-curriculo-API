class ActivitySequenceRating < ApplicationRecord
  belongs_to :activity_sequence_performed
  belongs_to :rating

  validates :activity_sequence_performed, uniqueness: { scope: :rating,
                                                        message: 'should happen once per rating' }
  validates :score, numericality: { only_integer: true,
                                    greater_than_or_equal_to: 0,
                                    less_than_or_equal_to: 5 }

  after_save :assign_evaluated_on_performeds
  after_destroy :remove_evaluated_on_performeds

  private

  def assign_evaluated_on_performeds
    activity_sequence_performed.update(evaluated: true)
  end

  def remove_evaluated_on_performeds
    return unless activity_sequence_performed.activity_sequence_ratings.count.zero?
    activity_sequence_performed.update(evaluated: false)
  end
end
