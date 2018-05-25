class CreateJoinTableActivitySequenceLearningObjective < ActiveRecord::Migration[5.2]
  def change
    create_join_table :activity_sequences, :learning_objectives do |t|
      t.index [:activity_sequence_id, :learning_objective_id], name: 'idx_activity_seq_learning_on_activity_seq_id_and_lo_id'
      t.index [:learning_objective_id, :activity_sequence_id], name: 'idx_activity_seq_learning_on_lo_id_and_activity_seq_id'
    end
  end
end
