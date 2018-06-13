class Roadmap < ApplicationRecord
  enum status: { soon: 0, executed: 1 }

  validates :title, presence: true, uniqueness: true
  validates :description, presence: true, uniqueness: true
  validates :status, presence: true
end
