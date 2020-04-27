class Stage < ApplicationRecord
  belongs_to :segment
  has_many :answer_book
  
  validates :name, presence: true
end
