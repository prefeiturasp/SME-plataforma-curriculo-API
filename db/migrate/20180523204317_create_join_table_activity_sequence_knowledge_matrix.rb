class CreateJoinTableActivitySequenceKnowledgeMatrix < ActiveRecord::Migration[5.2]
  def change
    create_join_table :activity_sequences, :knowledge_matrices do |t|
      t.index [:activity_sequence_id, :knowledge_matrix_id], name: 'idx_activity_seq_knowledge_on_activity_id_and_knowledge_id'
      t.index [:knowledge_matrix_id, :activity_sequence_id], name: 'idx_activity_seq_knowledge_on_knowledge_id_and_activity_id'
    end
  end
end
