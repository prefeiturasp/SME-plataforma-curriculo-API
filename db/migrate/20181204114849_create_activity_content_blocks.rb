class CreateActivityContentBlocks < ActiveRecord::Migration[5.2]
  def change
    create_table :activity_content_blocks do |t|
      t.belongs_to :activity, foreign_key: true
      t.belongs_to :content_block, foreign_key: true
      t.integer :sequence
      t.jsonb :content, null: false, default: "{}"

      t.timestamps
    end
  end
end
