class RemoveEmailUniqueIndex < ActiveRecord::Migration[5.2]
  def up
    remove_index :users, :email
    add_index :users, :email
    change_column :users, :email, :string, null: true, default: ""
  end

  def down
    remove_index :users, :email
    add_index :users, :email, unique: true
    change_column :users, :email, :string, null: false, default: ""
  end
end
