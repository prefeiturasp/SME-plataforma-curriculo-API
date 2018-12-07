class ContentBlock < ApplicationRecord

  enum content_type: {
    to_teacher: 0,
    to_student: 1,
    question:   2,
    predefined_exercise: 3,
    text: 4,
    gallery: 5
  }

  def self.partials_path
    'admin/activity_content_blocks/'
  end

  def fields
    JSON.parse(json_schema)
  end

  def self.all_fields
    all.map(&:fields).flatten.uniq
  end
end
