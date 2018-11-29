class CreateJoinTableLearningObjectiveAxis < ActiveRecord::Migration[5.2]
  def change
    create_join_table :learning_objectives, :axes
  end
end
