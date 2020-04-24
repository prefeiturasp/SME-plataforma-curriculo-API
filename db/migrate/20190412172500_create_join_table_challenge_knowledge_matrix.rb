class CreateJoinTableChallengeKnowledgeMatrix < ActiveRecord::Migration[5.2]
  def change
    create_join_table :challenges, :knowledge_matrices do |t|
      t.index [:challenge_id, :knowledge_matrix_id], name: 'index_c_km_on_km_c_id'
      t.index [:knowledge_matrix_id, :challenge_id], name: 'index_km_c_on_c_km_id'
    end
  end
end
