class AddClassNameToResults < ActiveRecord::Migration[5.2]
  def change
    add_column :results, :class_name, :string
  end
end
