class KnowledgeMatrix < ApplicationRecord
  has_and_belongs_to_many :activity_sequences

  validates :for_description, presence: true
  validates :know_description, presence: true
  validates :title, presence: true, uniqueness: true
  validates :sequence, presence: true, uniqueness: true

  def sequence_and_title
    "#{sequence} - #{title}"
  end
end
