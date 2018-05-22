class CreateLearningObjectives < ActiveRecord::Migration[5.2]
  def change
    create_table :learning_objectives do |t|
      t.integer :year
      t.string :code
      t.string :description
      t.belongs_to :curricular_component, foreign_key: true

      t.timestamps
    end
  end
end
