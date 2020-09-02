class ChangeColumnsFromPermittedActions < ActiveRecord::Migration[5.2]
  def change
    remove_column :permitted_actions, :action_name, :string
    add_column :permitted_actions, :class_name, :string
    add_column :permitted_actions, :name, :string
  end
end
