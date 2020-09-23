class CreateStudentProtagonism < ActiveRecord::Migration[5.2]
  def change
    create_table :student_protagonisms do |t|
      t.string  :description
      t.integer :sequence
      t.string  :title

      t.timestamps
    end
  end
end
