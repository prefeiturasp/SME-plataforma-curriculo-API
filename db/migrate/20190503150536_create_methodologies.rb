class CreateMethodologies < ActiveRecord::Migration[5.2]
  def change
    create_table :methodologies do |t|
      t.string :title
      t.string :slug
      t.text   :description

      t.timestamps
    end
  end
end
