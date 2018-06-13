class AddSlugToActivity < ActiveRecord::Migration[5.2]
  def self.up
    add_column :activities, :slug, :string
    add_index :activities, :slug, unique: true

    Activity.find_each(&:save)

    change_column :activities, :slug, :string, null: false
  end

  def self.down
    remove_index :activities, :slug
    remove_column :activities, :slug
  end
end
