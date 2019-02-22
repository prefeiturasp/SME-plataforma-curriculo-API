class CollectionActivitySequence < ApplicationRecord
  belongs_to :collection
  belongs_to :activity_sequence

  validates :activity_sequence_id, uniqueness: { scope: :collection_id }
  validates :sequence, numericality: { greater_than: 0 }, allow_nil: true

  after_commit :update_sequences

  def collection_activity_sequences_from_collection
    collection.collection_activity_sequences.order(:sequence, updated_at: :desc)
  end

  private

  def update_sequences
    return if valid_sequence?
    collection_activity_sequences_from_collection.each.with_index(1) do |col_act_seq, i|
      col_act_seq.update(sequence: i) if col_act_seq.sequence != i
    end
  end

  def valid_sequence?
    sequences = collection_activity_sequences_from_collection.pluck(:sequence)
    valid_sequence = (1..sequences.count).to_a

    sequences == valid_sequence
  end
end
