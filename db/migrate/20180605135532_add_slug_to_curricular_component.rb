class AddSlugToCurricularComponent < ActiveRecord::Migration[5.2]
  def self.up
    add_column :curricular_components, :slug, :string
    add_index :curricular_components, :slug, unique: true

    CurricularComponent.find_each(&:save)

    change_column :curricular_components, :slug, :string, null: false
  end

  def self.down
    remove_index :curricular_components, :slug
    remove_column :curricular_components, :slug
  end
  
end
