class AddAuthenticationTokenToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :authentication_token, :string
    add_column :users, :token_expires_at, :datetime
  end
end
