class CreateJoinTableSustainableDevelopmentGoalLearningObjective < ActiveRecord::Migration[5.2]
  def change
    create_join_table :sustainable_development_goals, :learning_objectives do |t|
      t.index [:sustainable_development_goal_id, :learning_objective_id], name: 'index_sdg_lo_on_sdg_id_alo_id'
      t.index [:learning_objective_id, :sustainable_development_goal_id], name: 'index_sdg_lo_on_lo_id_asdg_id'
    end
  end
end
