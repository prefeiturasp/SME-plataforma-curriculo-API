class AddColumnDevelopmentClassToProject < ActiveRecord::Migration[5.2]
  def change
    add_column :projects, :development_class, :string
  end
end
