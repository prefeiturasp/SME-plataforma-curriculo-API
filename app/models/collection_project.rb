class CollectionProject < ApplicationRecord
  belongs_to :collection
  belongs_to :project

  validates :project_id, uniqueness: { scope: :collection_id }
  validates :sequence, numericality: { greater_than: 0 }, allow_nil: true

  after_commit :update_sequences

  def collection_projects_from_collection
    collection.collection_projects.order(:sequence, updated_at: :desc)
  end

  private

  def update_sequences
    return if valid_sequence?
    collection_projects_from_collection.each.with_index(1) do |col_act_seq, i|
      col_act_seq.update(sequence: i) if col_act_seq.sequence != i
    end
  end

  def valid_sequence?
    sequences = collection_projects_from_collection.pluck(:sequence)
    valid_sequence = (1..sequences.count).to_a

    sequences == valid_sequence
  end
end
