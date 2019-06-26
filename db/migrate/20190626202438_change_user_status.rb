class ChangeUserStatus < ActiveRecord::Migration[5.2]
  def change
    User.joins(:teacher).where(admin: true).update_all(admin: false)
  end
end
