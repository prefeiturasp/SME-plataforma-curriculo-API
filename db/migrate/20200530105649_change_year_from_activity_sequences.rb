class ChangeYearFromActivitySequences < ActiveRecord::Migration[5.2]
  def change
    remove_column :activity_sequences, :year
    add_reference :activity_sequences, :year, index: true
  end
end
