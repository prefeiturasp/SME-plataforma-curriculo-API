class CreateActivities < ActiveRecord::Migration[5.2]
  def change
    create_table :activities do |t|
      t.integer :sequence
      t.string :title
      t.integer :estimated_time
      t.json :content
      t.belongs_to :activity_sequence, foreign_key: true

      t.timestamps
    end
  end
end
