class CreateSchools < ActiveRecord::Migration[5.2]
  def change
    create_table :schools do |t|
      t.string :code
      t.string :name
      t.string :school_type

      t.belongs_to :regional_education_board, foreign_key: true
      t.timestamps
    end
  end
end
