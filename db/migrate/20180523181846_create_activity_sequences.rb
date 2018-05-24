class CreateActivitySequences < ActiveRecord::Migration[5.2]
  def change
    create_table :activity_sequences do |t|
      t.string :title
      t.integer :year
      t.text :presentation_text
      t.text :books
      t.integer :estimated_time
      t.integer :status
      t.references :main_curricular_component, index: true, foreign_key: { to_table: :curricular_components }

      t.timestamps
    end
  end
end
