class CreateCollectionActivitySequences < ActiveRecord::Migration[5.2]
  def change
    create_table :collection_activity_sequences do |t|
      t.belongs_to :collection, foreign_key: true
      t.belongs_to :activity_sequence, foreign_key: true
      t.integer :sequence

      t.timestamps
    end
  end
end
