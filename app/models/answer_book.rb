class AnswerBook < ApplicationRecord
  belongs_to :curricular_component
  belongs_to :stage
  belongs_to :segment
  belongs_to :year

  validates :name, presence: true
  validates :cover_image, presence: true
  validates :book_file, presence: true

  mount_uploader :cover_image, AnswerBookImageUploader
  mount_uploader :book_file, AnswerBookFileUploader
end
