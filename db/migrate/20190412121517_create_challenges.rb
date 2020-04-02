class CreateChallenges < ActiveRecord::Migration[5.2]
  def change
    create_table :challenges do |t|
      t.string  :slug, unique: true
      t.string  :title, unique: true
      t.string  :keywords
      t.date    :finish_at
      t.integer :category
      t.integer :status

      t.timestamps
    end
  end
end
