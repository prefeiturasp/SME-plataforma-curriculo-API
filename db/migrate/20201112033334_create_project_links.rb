class CreateProjectLinks < ActiveRecord::Migration[5.2]
  def change
    create_table :project_links do |t|
      t.string :link

      t.timestamps

      t.belongs_to :project, foreign_key: true
    end
  end
end
