class AddJwtJtiToUsers < ActiveRecord::Migration[5.2]
  def change
    # required by devise-jwt
    add_column :users, :jti, :string
    User.all.each { |user| user.update_column(:jti, SecureRandom.uuid) }
    change_column_null :users, :jti, false
    add_index :users, :jti, unique: true

    # required by sme-jwt-strategy
    add_column :users, :sme_token, :string
    add_column :users, :sme_refresh_token, :string
    add_index  :users, :sme_token
    add_index  :users, :sme_refresh_token
  end
end
