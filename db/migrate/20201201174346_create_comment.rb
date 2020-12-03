class CreateComment < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
      t.string :body
      t.belongs_to :teacher, foreign_key: true
      t.belongs_to :project, foreign_key: true

      t.timestamps
    end
  end
end
