class CreateLinks < ActiveRecord::Migration[5.2]
  def change
    create_table :links do |t|
      t.integer :linkable_id, index: true
      t.string  :linkable_type, index: true
      t.string  :link
    end
  end
end
