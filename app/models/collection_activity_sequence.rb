class CollectionActivitySequence < ApplicationRecord
  belongs_to :collection
  belongs_to :activity_sequence

  validates :activity_sequence_id, uniqueness:  { scope: :collection_id }
end
