class CreateFavourites < ActiveRecord::Migration[5.2]
  def change
    create_table :favourites do |t|
      t.integer    :favouritable_id, index: true
      t.string     :favouritable_type, index: true
      t.belongs_to :teacher, foreign_key: true

      t.timestamps
    end

    add_index :favourites,
              [:teacher_id, :favouritable_id, :favouritable_type],
              unique: true,
              name: 'favourites_unique_index'
  end
end
