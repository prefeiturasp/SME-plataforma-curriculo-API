class CreateJoinTableActivitySequenceSustainableDevelopmentGoal < ActiveRecord::Migration[5.2]
  def change
    create_join_table :activity_sequences, :sustainable_development_goals do |t|
      t.index [:activity_sequence_id, :sustainable_development_goal_id], name: 'index_activity_seq_sdg_on_activity_seq_id_and_sdg_id'
      t.index [:sustainable_development_goal_id, :activity_sequence_id], name: 'index_activity_seq_sdg_on_sdg_id_and_activity_seq_id'
    end
  end
end
