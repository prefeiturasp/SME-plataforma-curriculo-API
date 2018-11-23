class Collection < ApplicationRecord
  belongs_to :teacher

  validates :name, presence: true, length: { maximum: 30 }
end
