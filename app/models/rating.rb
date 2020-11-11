class Rating < ApplicationRecord
  include SequenceConcern

  has_many :activity_sequence_ratings

  scope :enableds, -> { where(enable: true) }

  validates :description, presence: true, uniqueness: true
  validates :enable, inclusion: { in: [true, false] }

  def self.enabled_rating_ids
    enableds.pluck(:id).sort()
  end
end
