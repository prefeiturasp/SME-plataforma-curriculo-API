class CreateCollectionProjects < ActiveRecord::Migration[5.2]
  def change
    create_table :collection_projects do |t|
      t.belongs_to :collection, foreign_key: true
      t.belongs_to :project, foreign_key: true
      t.integer :sequence

      t.timestamps
    end
  end
end
