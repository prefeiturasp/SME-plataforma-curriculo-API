class CreateYears < ActiveRecord::Migration[5.2]
  def change
    create_table :years do |t|
      t.string :name

      t.belongs_to :segment, foreign_key: true
      t.belongs_to :stage, foreign_key: true
    end
  end
end
