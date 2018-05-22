class KnowledgeMatrix < ApplicationRecord
  validates :title, presence: true, uniqueness: true
  validates :know_description, presence: true
  validates :for_description, presence: true
  validates :sequence, presence: true, uniqueness: true
end
