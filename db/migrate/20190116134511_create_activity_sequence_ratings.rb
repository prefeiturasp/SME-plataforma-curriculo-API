class CreateActivitySequenceRatings < ActiveRecord::Migration[5.2]
  def change
    create_table :activity_sequence_ratings do |t|
      t.belongs_to :activity_sequence_performed,
                   foreign_key: true,
                   index: { name: 'index_activity_seq_ratings_on_activity_seq_performed_id' }
      t.belongs_to :rating, foreign_key: true
      t.integer :score

      t.timestamps
    end
  end
end
