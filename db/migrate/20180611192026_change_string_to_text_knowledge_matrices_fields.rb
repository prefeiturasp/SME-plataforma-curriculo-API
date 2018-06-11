class ChangeStringToTextKnowledgeMatricesFields < ActiveRecord::Migration[5.2]
  def change
    change_column :knowledge_matrices, :know_description, :text
    change_column :knowledge_matrices, :for_description,  :text
  end
end
