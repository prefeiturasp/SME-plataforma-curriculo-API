class ChangeActivitySequenceBookFieldToJsonB < ActiveRecord::Migration[5.2]
  def up
    ActivitySequence.update_all(books: nil)
    # 'ALTER TABLE table_with_json ALTER COLUMN my_json SET DATA TYPE jsonb USING my_json::jsonb'
    change_column :activity_sequences, :books, :jsonb, using: 'books::text::jsonb'
  end

  def down
    # irreversible :/
  end
end
