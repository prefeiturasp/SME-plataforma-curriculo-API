class CreateJoinTableProjectLearningObjective < ActiveRecord::Migration[5.2]
  def change
    create_join_table :projects, :learning_objectives
  end
end
