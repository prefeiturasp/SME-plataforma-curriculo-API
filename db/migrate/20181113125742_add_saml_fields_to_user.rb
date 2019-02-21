class AddSamlFieldsToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :uid, :string
    add_column :users, :name, :string
    add_column :users, :last_name, :string
    add_column :users, :session_index, :string
  end
end
