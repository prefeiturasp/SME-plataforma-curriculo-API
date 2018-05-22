class CreateKnowledgeMatrices < ActiveRecord::Migration[5.2]
  def change
    create_table :knowledge_matrices do |t|
      t.string :title
      t.string :know_description
      t.string :for_description
      t.integer :sequence

      t.timestamps
    end
  end
end
