class ActivityContentBlock < ApplicationRecord
  include ConvertImageConcern

  belongs_to :activity
  belongs_to :content_block
  has_many :images, dependent: :destroy

  after_initialize :initialize_dynamic_contents
  before_validation :check_required_fields
  before_save :change_format_content_images

  accepts_nested_attributes_for :images, allow_destroy: true

  def initialize_dynamic_contents
    ContentBlock.all_fields.each do |field|
      create_dynamic_getter(field)
      create_dynamic_setter(field)
      assign_default_content(field)
    end
  end

  def content_hash
    return {} unless content
    JSON.parse(content)
  end

  private

  def change_format_content_images
    return nil if content_hash['body'].blank?
    content = JSON.parse(content_hash['body'])
    content['ops'].each do |c|
      uri_parts = extract_image(c['insert']['image'])
      next if uri_parts.blank?
      c['insert']['image'] = base64_to_url(uri_parts)
    end

    self.content = content.to_json
  end

  def assign_default_content(field)
    new_content = content_hash ? content_hash[field] : nil
    send("#{field}=".to_sym, new_content)
  end

  def create_dynamic_getter(field)
    self.class.send(:define_method, field.to_sym) do
      instance_variable_get('@' + field.to_s)
    end
  end

  def create_dynamic_setter(field)
    self.class.send(:define_method, "#{field}=".to_sym) do |value|
      if value
        new_content_hash = content_hash.merge!("#{field}": value)
        self[:content] = new_content_hash.to_json
      end
      instance_variable_set('@' + field.to_s, value)
    end
  end

  def check_required_fields
    return if content_block.required_fields.blank?
    content_block.required_fields.each do |field|
      errors.add(field, 'é obrigatório') if send(field).blank?
    end
  end
end
