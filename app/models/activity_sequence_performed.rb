class ActivitySequencePerformed < ApplicationRecord
  belongs_to :activity_sequence
  belongs_to :teacher
  has_many   :activity_sequence_ratings

  validates :activity_sequence, uniqueness: { scope: :teacher,
                                              message: 'should happen once per teacher' }

  scope :by_teacher, ->(teacher) {
    where(teacher_id: teacher.id)
  }
  scope :evaluateds, -> { where(evaluated: true) }
  scope :not_evaluateds, -> { where(evaluated: false) }
  scope :ordered_by_created_at, -> { order(created_at: :asc) }

  def self.all_or_with_evaluated(evaluated = nil)
    return all if evaluated.nil?
    where(evaluated: evaluated)
  end
end
