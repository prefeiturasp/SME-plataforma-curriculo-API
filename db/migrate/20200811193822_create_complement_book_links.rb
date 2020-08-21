class CreateComplementBookLinks < ActiveRecord::Migration[5.2]
  def change
    create_table :complement_book_links do |t|
      t.string :link

      t.timestamps

      t.belongs_to :complement_book, foreign_key: true
    end
  end
end
