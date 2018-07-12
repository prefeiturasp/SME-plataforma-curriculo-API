class CreateJoinTableActivityLearningObjective < ActiveRecord::Migration[5.2]
  def change
    create_join_table :activities, :learning_objectives do |t|
      t.index [:activity_id, :learning_objective_id], name: 'idx_activity_learning_on_activity_id_and_lo_id'
      t.index [:learning_objective_id, :activity_id], name: 'idx_activity_learning_on_lo_id_and_activity_id'
    end
  end
end
