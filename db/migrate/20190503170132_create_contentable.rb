class CreateContent < ActiveRecord::Migration[5.2]
  def change
    create_table :content do |t|
      t.integer    :contentable_id
      t.string     :contentable_type
      t.belongs_to :content_block, foreign_key: true
      t.integer    :sequence
      t.jsonb      :content, null: false, default: "{}"

      t.timestamps
    end

    add_index :content, [:contentable_type, :contentable_id]
  end
end
