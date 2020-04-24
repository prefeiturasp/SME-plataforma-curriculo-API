class Segment < ApplicationRecord
  has_many :stages
  has_many :answer_books

  validates :name, presence: true
end
