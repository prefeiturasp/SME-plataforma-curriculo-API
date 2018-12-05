class ActivityContentBlock < ApplicationRecord
  belongs_to :activity
  belongs_to :content_block

  attr_accessor :body, :title, :number, :content_type, :teste

  # t.belongs_to :activity, foreign_key: true
  # t.belongs_to :content_block, foreign_key: true
  # t.integer :sequence
  # t.jsonb :content, null: false, default: "{}"

  def body    
    content_json['body']
  end

  def content_type
    content_json['content_type']
  end

  def content_json
    return unless content
    JSON.parse(content)
  end
end
