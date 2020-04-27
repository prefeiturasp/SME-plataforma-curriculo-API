class AddStageRefToActivitySequence < ActiveRecord::Migration[5.2]
  def change
    add_reference :activity_sequences, :stage, index: true
  end
end
