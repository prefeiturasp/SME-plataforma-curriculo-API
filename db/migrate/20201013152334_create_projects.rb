class CreateProjects < ActiveRecord::Migration[5.2]
  def change
    create_table :projects do |t|
      t.string :old_id
      t.string :title
      t.string :school
      t.string :dre
      t.string :description
      t.string :summary
      t.string :owners

      t.timestamps
    end
  end
end
