class AddKeywordsToActivitySequences < ActiveRecord::Migration[5.2]
  def change
    add_column :activity_sequences, :keywords, :string
  end
end
