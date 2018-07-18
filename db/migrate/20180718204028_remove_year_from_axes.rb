class RemoveYearFromAxes < ActiveRecord::Migration[5.2]
  def change
    remove_column :axes, :year
  end
end
