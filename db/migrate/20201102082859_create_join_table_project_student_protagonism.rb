class CreateJoinTableProjectStudentProtagonism < ActiveRecord::Migration[5.2]
  def change
    create_join_table :projects, :student_protagonisms    
  end
end
