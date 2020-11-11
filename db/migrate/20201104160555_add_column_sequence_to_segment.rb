class AddColumnSequenceToSegment < ActiveRecord::Migration[5.2]
  def change
    add_column :segments, :sequence, :integer
  end
end
