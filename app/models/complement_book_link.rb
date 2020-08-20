class ComplementBookLink < ApplicationRecord
  belongs_to :complement_book
  validates :link, presence: true
end
