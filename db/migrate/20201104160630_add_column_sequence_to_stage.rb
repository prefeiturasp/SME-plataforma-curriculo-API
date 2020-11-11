class AddColumnSequenceToStage < ActiveRecord::Migration[5.2]
  def change
    add_column :stages, :sequence, :integer
  end
end
