class CreateSustainableDevelopmentGoals < ActiveRecord::Migration[5.2]
  def change
    create_table :sustainable_development_goals do |t|
      t.integer :sequence
      t.string :name
      t.string :description
      t.string :goals

      t.timestamps
    end
  end
end
