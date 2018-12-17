class AddStatusToActivity < ActiveRecord::Migration[5.2]
  def change
    add_column :activities, :status, :integer, default: 1
  end
end
