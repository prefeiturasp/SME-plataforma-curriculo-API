class Segment < ApplicationRecord
  has_many :stages
  has_many :answer_books
  has_many :activity_sequences
  has_many :learning_objectives

  validates :name, presence: true
  validates :color, presence: true
end
