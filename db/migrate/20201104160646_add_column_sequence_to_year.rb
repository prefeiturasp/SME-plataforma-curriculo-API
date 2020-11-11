class AddColumnSequenceToYear < ActiveRecord::Migration[5.2]
  def change
    add_column :years, :sequence, :integer
  end
end
