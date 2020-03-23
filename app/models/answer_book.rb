class AnswerBook < ApplicationRecord
  belongs_to :curricular_component

  validates :name, presence: true
  validates :cover_image, presence: true
  validates :book_file, presence: true

  mount_uploader :cover_image, AnswerBookFilesUploader
  mount_uploader :book_file, AnswerBookFilesUploader
end
