class RemoveSuperadminFromUsers < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :superadmin, :boolean
  end
end
