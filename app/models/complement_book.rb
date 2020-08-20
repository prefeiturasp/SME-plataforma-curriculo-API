class ComplementBook < ApplicationRecord
  belongs_to :partner
  has_many :complement_book_links, dependent: :destroy
  accepts_nested_attributes_for :complement_book_links, allow_destroy: true

  validates :name, presence: true
  validates :cover_image, presence: true
  validates :book_file, presence: true

  mount_uploader :cover_image, ComplementBookImageUploader
  mount_uploader :book_file, ComplementBookFileUploader
end
