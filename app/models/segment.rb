class Segment < ApplicationRecord
  has_many :stages
  has_many :answer_books
  has_many :activity_sequence
  has_many :learning_objective

  validates :name, presence: true
end
