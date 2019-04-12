class CreateChallengeContentBlock < ActiveRecord::Migration[5.2]
  def change
    create_table :challenge_content_blocks do |t|
      t.belongs_to :challenge, foreign_key: true
      t.belongs_to :content_block, foreign_key: true
      t.integer :sequence
      t.jsonb :content, null: false, default: "{}"

      t.timestamps
    end
  end
end
