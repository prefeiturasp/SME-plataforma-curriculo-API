class AddSlugToActivitySequence < ActiveRecord::Migration[5.2]
  def self.up
    add_column :activity_sequences, :slug, :string
    add_index :activity_sequences, :slug, unique: true

    ActivitySequence.find_each(&:save)

    change_column :activity_sequences, :slug, :string, null: false
  end

  def self.down
    remove_index :activity_sequences, :slug
    remove_column :activity_sequences, :slug
  end
end
