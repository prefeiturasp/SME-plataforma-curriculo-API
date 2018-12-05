class ContentBlock < ApplicationRecord

  enum content_type: {
    to_teacher: 0,
    to_student: 1,
    question:   2,
    predefined_exercise: 3,
    text: 4,
    gallery: 5
  }
end
