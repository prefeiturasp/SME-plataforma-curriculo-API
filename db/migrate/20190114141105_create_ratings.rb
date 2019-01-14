class CreateRatings < ActiveRecord::Migration[5.2]
  def change
    create_table :ratings do |t|
      t.integer :sequence
      t.text :description
      t.boolean :enable, default: true, null: false

      t.timestamps
    end
  end
end
