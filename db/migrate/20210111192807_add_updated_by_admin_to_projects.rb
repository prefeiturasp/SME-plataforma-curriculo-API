class AddUpdatedByAdminToProjects < ActiveRecord::Migration[5.2]
  def change
    add_column :projects, :updated_by_admin, :boolean
  end
end
