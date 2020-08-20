class Partner < ApplicationRecord
  has_many :complement_books, dependent: :destroy
  accepts_nested_attributes_for :complement_books, allow_destroy: true
  validates :name, presence: true
end
