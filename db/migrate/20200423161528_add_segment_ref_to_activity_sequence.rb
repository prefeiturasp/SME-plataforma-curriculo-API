class AddSegmentRefToActivitySequence < ActiveRecord::Migration[5.2]
  def change
    add_reference :activity_sequences, :segment, index: true
  end
end
