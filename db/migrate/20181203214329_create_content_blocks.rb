class CreateContentBlocks < ActiveRecord::Migration[5.2]
  def change
    create_table :content_blocks do |t|
      t.integer :content_type
      t.jsonb :json_schema, null: false, default: "{}"

      t.timestamps
    end
  end
end
