class AddSlugToProject < ActiveRecord::Migration[5.2]
  def self.up
    add_column :projects, :slug, :string
    add_index :projects, :slug, unique: true

    Project.find_each(&:save)

    change_column :projects, :slug, :string, null: false
  end

  def self.down
    remove_index :projects, :slug
    remove_column :projects, :slug
  end
end
