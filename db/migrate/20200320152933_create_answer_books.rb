class CreateAnswerBooks < ActiveRecord::Migration[5.2]
  def change
    execute <<-SQL
      CREATE TYPE education_level AS ENUM ('kid', 'special', 'basic', 'eja', 'guide');
    SQL
    create_table :answer_books do |t|
      t.string :name
      t.string :cover_image
      t.string :book_file
      t.string :year
      t.column :level, :education_level

      t.timestamps

      t.belongs_to :curricular_component, foreign_key: true
    end
  end
end

