class Activity < ApplicationRecord
  include ImageConcern
  belongs_to :activity_sequence
  has_and_belongs_to_many :activity_types

  validates :title, presence: true, uniqueness: true
  validates :sequence, presence: true, uniqueness: true
  validates :estimated_time, presence: true
  validates :content, presence: true


  has_many_attached :content_images


  before_save do
    JSON.parse(content)
  end
end
