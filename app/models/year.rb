class Year < ApplicationRecord
  belongs_to :segment
  belongs_to :stage
  has_many :answer_book

  validates :name, presence: true
end
