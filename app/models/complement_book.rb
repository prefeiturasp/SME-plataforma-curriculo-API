class ComplementBook < ApplicationRecord
  belongs_to :curricular_component

  validates :name, presence: true
  validates :cover_image, presence: true
  validates :book_file, presence: true

  mount_uploader :cover_image, ComplementBookImageUploader
  mount_uploader :book_file, ComplementBookFileUploader
end
