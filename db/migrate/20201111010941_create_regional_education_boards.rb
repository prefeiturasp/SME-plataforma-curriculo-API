class CreateRegionalEducationBoards < ActiveRecord::Migration[5.2]
  def change
    create_table :regional_education_boards do |t|
      t.string :code
      t.string :name
      t.string :tag

      t.timestamps
    end
  end
end
