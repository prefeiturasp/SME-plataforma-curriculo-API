module SequenceConcern
  extend ActiveSupport::Concern

  included do
    validates :sequence, presence: true

    after_save    :update_sequences, on: %i[create update]
    after_destroy :update_sequences
  end

  private

  def update_sequences
    return if valid_sequence?
    self.class.order(:sequence, updated_at: :desc).each.with_index(1) do |k, i|
      k.update_column(:sequence, i) if k.sequence != i
    end
  end

  def valid_sequence?
    sequences = self.class.order(:sequence).pluck(:sequence)
    valid_sequence = (1..sequences.count).to_a

    sequences == valid_sequence
  end
end
