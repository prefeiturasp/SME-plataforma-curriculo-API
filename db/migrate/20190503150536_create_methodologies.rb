class CreateMethodologies < ActiveRecord::Migration[5.2]
  def change
    create_table :methodologies do |t|
      t.string :title
      t.string :slug
      t.string :subtitle
      t.text   :description
      t.text   :content

      t.timestamps
    end
  end
end
