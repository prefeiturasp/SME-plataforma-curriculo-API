class CreateAnswerBooks < ActiveRecord::Migration[5.2]
  def change
    create_table :answer_books do |t|
      t.string :name
      t.string :cover_image
      t.string :book_file

      t.timestamps

      t.belongs_to :curricular_component, foreign_key: true
    end
  end
end
