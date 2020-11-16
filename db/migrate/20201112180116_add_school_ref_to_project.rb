class AddSchoolRefToProject < ActiveRecord::Migration[5.2]
  def change
    add_reference :projects, :school, index: true
  end
end
