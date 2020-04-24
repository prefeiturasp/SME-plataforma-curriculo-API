class CreateJoinTableChallengeLearningObjective < ActiveRecord::Migration[5.2]
  def change
    create_join_table :challenges, :learning_objectives do |t|
      t.index [:challenge_id, :learning_objective_id], name: 'index_c_lo_on_c_id_alo_id'
      t.index [:learning_objective_id, :challenge_id], name: 'index_c_lo_on_lo_id_ac_id'
    end
  end
end
