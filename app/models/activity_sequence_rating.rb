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

  def self.create_multiples(array_params)
    return unless contains_all_enabled_ratings?(array_params)
    ActivitySequenceRating.transaction do
      array_params.each do |params|
        @activity_sequence_rating = save_or_raise_rollback(params)
      end
    end

    @activity_sequence_rating
  end

  def self.contains_all_enabled_ratings?(array_params)
    rating_ids = array_params.map { |params| params[:rating_id].to_i }
    Rating.enabled_rating_ids.sort == rating_ids.sort
  end

  def self.save_or_raise_rollback(params)
    @activity_sequence_rating = ActivitySequenceRating.new(params)
    raise ActiveRecord::Rollback unless @activity_sequence_rating.save

    @activity_sequence_rating
  end

  private

  def assign_evaluated_on_performeds
    activity_sequence_performed.update(evaluated: true)
  end

  def remove_evaluated_on_performeds
    return unless activity_sequence_performed.activity_sequence_ratings.count.zero?
    activity_sequence_performed.update(evaluated: false)
  end
end
