class ChangeSchoolToSchoolNameFromProject < ActiveRecord::Migration[5.2]
  def change
    rename_column :projects, :school, :school_name
  end
end
