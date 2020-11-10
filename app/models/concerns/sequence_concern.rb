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
    self.class.order(:sequence).each_with_index do |obj, idx|
      if (self.sequence == 1 && obj.sequence == 1 && obj != self)
        obj.update_column(:sequence, 2)
      elsif self.id == obj.id
        next
      else
        obj.update_column(:sequence, idx + 1)
      end
    end
  end

  def valid_sequence?
    sequences = self.class.order(:sequence).pluck(:sequence)
    valid_sequence = (1..sequences.count).to_a

    sequences == valid_sequence
  end
end
