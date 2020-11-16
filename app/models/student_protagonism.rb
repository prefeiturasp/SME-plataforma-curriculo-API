class StudentProtagonism < ApplicationRecord
  include SequenceConcern

  has_and_belongs_to_many :projects

  validates :title, presence: true
  validates :description, presence: true
  validates :sequence, presence: true

  def sequence_and_title
    "#{sequence} - #{title}"
  end
end
