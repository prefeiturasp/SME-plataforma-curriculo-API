class CreateCurriculumSubjects < ActiveRecord::Migration[5.2]
  def change
    create_table :curriculum_subjects do |t|
      t.string :old_id
      t.string :name
    end
  end
end
