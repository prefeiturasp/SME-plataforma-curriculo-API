class CreateCollections < ActiveRecord::Migration[5.2]
  def change
    create_table :collections do |t|
      t.string :name
      t.belongs_to :teacher, foreign_key: true

      t.timestamps
    end
  end
end
