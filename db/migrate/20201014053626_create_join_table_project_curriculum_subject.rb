class CreateJoinTableProjectCurriculumSubject < ActiveRecord::Migration[5.2]
  def change
    create_join_table :projects, :curriculum_subjects
  end
end
