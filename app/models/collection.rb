class Collection < ApplicationRecord
  belongs_to :teacher
  has_many :collection_activity_sequences
  has_many :activity_sequences,
           -> { order 'collection_activity_sequences.sequence ASC' },
           through: :collection_activity_sequences

  validates :name, presence: true, length: { maximum: 30 }

  accepts_nested_attributes_for :collection_activity_sequences, allow_destroy: true
end
