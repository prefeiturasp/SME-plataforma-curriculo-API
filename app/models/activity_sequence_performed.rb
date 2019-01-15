class ActivitySequencePerformed < ApplicationRecord
  belongs_to :activity_sequence
  belongs_to :teacher

  scope :by_teacher, ->(teacher) {
    where(teacher_id: teacher.id)
  }
  scope :evaluateds, -> { where(evaluated: true) }
  scope :ordered_by_created_at, -> { order(created_at: :asc) }

  def self.all_or_with_evaluated(evaluated = nil)
    return all if evaluated.nil?
    where(evaluated: evaluated)
  end
end
