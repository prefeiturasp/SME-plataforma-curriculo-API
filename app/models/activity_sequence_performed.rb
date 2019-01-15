class ActivitySequencePerformed < ApplicationRecord
  belongs_to :activity_sequence
  belongs_to :teacher

  scope :by_teacher, ->(teacher) {
    where(teacher_id: teacher.id)
  }
  scope :evaluateds, -> { where(evaluated: true) }
  scope :ordered_by_created_at, -> { order(created_at: :asc) }
end
