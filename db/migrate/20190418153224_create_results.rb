class CreateResults < ActiveRecord::Migration[5.2]
  def change
    create_table :results do |t|
      t.belongs_to :challenge, foreign_key: true
      t.belongs_to :teacher, foreign_key: true
      t.boolean :enabled, default: true
      t.text :description

      t.timestamps
    end
  end
end
