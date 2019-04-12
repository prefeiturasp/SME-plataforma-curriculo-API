class ContentBlock < ApplicationRecord
  enum content_type: {
    to_teacher: 0,
    to_student: 1,
    question:   2,
    predefined_exercise: 3,
    long_text: 4,
    gallery: 5,
    free_text: 6
  }

  validates :content_type, presence: true, uniqueness: true

  def self.partials_path
    #'admin/activity_content_blocks/'
    'admin/partials/blocks/'
  end

  def fields
    JSON.parse(json_schema)['properties'].keys
  end

  def field_collection(field_name)
    options = JSON.parse(json_schema)['properties'][field_name.to_s]
    arr_values = options.slice('enum').values.first
    arr_values.present? ? arr_values.map { |k| [k, k] } : []
  end

  def self.all_fields
    all.map(&:fields).flatten.uniq
  end

  def required_fields
    JSON.parse(json_schema)['required']
  end

  def self.human_attribute_content_blocks
    ContentBlock.content_types.map { |k, _v| [I18n.t("activerecord.attributes.enums.content_types.#{k}"), k] }
  end
end
