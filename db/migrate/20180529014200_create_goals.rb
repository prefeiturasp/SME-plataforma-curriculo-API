class CreateGoals < ActiveRecord::Migration[5.2]
  def change
    create_table :goals do |t|
      t.text :description
      t.belongs_to :sustainable_development_goal, foreign_key: true

      t.timestamps
    end
  end
end
