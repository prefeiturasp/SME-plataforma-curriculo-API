class RemoveJoinTableActivityActivityType < ActiveRecord::Migration[5.2]
  def change
    drop_join_table :activities, :activity_types
  end
end
