class AddYearToAxis < ActiveRecord::Migration[5.2]
  def change
    add_column :axes, :year, :integer
  end
end
