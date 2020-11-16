class AddColumnDevelopmentYearToProject < ActiveRecord::Migration[5.2]
  def change
    add_column :projects, :development_year, :string
  end
end
