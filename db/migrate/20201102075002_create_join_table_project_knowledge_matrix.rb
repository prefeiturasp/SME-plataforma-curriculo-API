class CreateJoinTableProjectKnowledgeMatrix < ActiveRecord::Migration[5.2]
  def change
    create_join_table :projects, :knowledge_matrices
  end
end
