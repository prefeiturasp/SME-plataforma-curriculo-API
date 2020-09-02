class CreateJoinTableUserPermittedAction < ActiveRecord::Migration[5.2]
  def change
    create_join_table :users, :permitted_actions
  end
end
