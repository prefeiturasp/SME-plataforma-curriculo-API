class KnowledgeMatrix < ApplicationRecord
  validates :for_description, presence: true
  validates :know_description, presence: true
  validates :title, presence: true, uniqueness: true
  validates :sequence, presence: true, uniqueness: true
end
