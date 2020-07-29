class AddDreToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :dre, :string
  end
end
