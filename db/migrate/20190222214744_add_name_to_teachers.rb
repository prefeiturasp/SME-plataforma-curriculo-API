class AddNameToTeachers < ActiveRecord::Migration[5.2]
  def change
    add_column :teachers, :name, :string
  end
end
