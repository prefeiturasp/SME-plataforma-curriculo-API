class ActivityContentBlock < ApplicationRecord
  belongs_to :activity
  belongs_to :content_block
  has_many :images, dependent: :destroy

  after_initialize :initialize_dynamic_contents
  before_validation :check_required_fields

  accepts_nested_attributes_for :images, allow_destroy: true

  def initialize_dynamic_contents
    ContentBlock.all_fields.each do |field|
      # Create Getters
      self.class.send(:define_method, field.to_sym) do
        instance_variable_get("@" + field.to_s)
      end

      # Create Setters
      self.class.send(:define_method, "#{field}=".to_sym) do |value|
        if value
          new_content_hash = content_hash.merge!("#{field}": value)
          self[:content] = new_content_hash.to_json
        end
        instance_variable_set("@" + field.to_s, value)
      end

      # Set default contents from content json
      new_content = content_hash ? content_hash[field] : nil
      self.send("#{field}=".to_sym, new_content)
    end
  end

  def content_hash
    return {} unless content
    JSON.parse(content)
  end

  private

  def check_required_fields
    return if content_block.required_fields.blank?
    content_block.required_fields.each do |field|
      errors.add(field, "é obrigatório") if send(field).blank?
    end
  end
end
