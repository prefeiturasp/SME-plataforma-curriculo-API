class AddColorToSegments < ActiveRecord::Migration[5.2]
  def change
    add_column :segments, :color, :string
  end
end
