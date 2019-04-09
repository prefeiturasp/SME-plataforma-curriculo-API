class RemoveDeviseTokenAuthFields < ActiveRecord::Migration[5.2]
  def change
    remove_index  :users, [:uid, :provider]
    remove_column :users, :uid
    remove_column :users, :name
    remove_column :users, :last_name
    remove_column :users, :session_index
    remove_column :users, :provider
    remove_column :users, :nickname
    remove_column :users, :tokens
  end
end
