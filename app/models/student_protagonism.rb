class StudentProtagonism < ApplicationRecord
  include SequenceConcern

  validates :title, presence: true
  validates :description, presence: true
  validates :sequence, presence: true

  def sequence_and_title
    "#{sequence} - #{title}"
  end
end
