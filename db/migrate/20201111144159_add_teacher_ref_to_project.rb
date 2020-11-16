class AddTeacherRefToProject < ActiveRecord::Migration[5.2]
  def change
    add_reference :projects, :teacher, index: true
  end
end
