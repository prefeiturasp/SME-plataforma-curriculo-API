class CreateImages < ActiveRecord::Migration[5.2]
  def change
    create_table :images do |t|
      t.string :subtitle
      t.belongs_to :activity_content_block, foreign_key: true

      t.timestamps
    end
  end
end
