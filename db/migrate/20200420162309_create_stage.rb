class CreateStage < ActiveRecord::Migration[5.2]
  def change
    create_table :stages do |t|
      t.string :name
    
      t.belongs_to :segment, foreign_key: true
    end
  end
end
