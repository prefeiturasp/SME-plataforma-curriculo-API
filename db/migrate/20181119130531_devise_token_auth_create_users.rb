class DeviseTokenAuthCreateUsers < ActiveRecord::Migration[5.2]
  def change
    ## Required
    add_column :users, :provider, :string, null: false, default: 'email'
    # add_column :users, :uid, :string, null: false, default: ''

    ## User Info
    # add_column :users, :name, :string
    add_column :users, :nickname, :string

    ## Tokens
    add_column :users, :tokens, :json
  

    add_index :users, [:uid, :provider], unique: true
  end
end
