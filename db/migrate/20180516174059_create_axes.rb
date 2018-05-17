class CreateAxes < ActiveRecord::Migration[5.2]
  def change
    create_table :axes do |t|
      t.string :description
      t.belongs_to :curricular_component, foreign_key: true

      t.timestamps
    end
  end
end
