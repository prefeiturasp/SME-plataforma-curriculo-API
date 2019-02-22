class CreateActivitySequencePerformeds < ActiveRecord::Migration[5.2]
  def change
    create_table :activity_sequence_performeds do |t|
      t.belongs_to :activity_sequence, foreign_key: true
      t.belongs_to :teacher, foreign_key: true
      t.boolean    :evaluated, default: false, null: false

      t.timestamps
    end
  end
end
