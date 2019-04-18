class CreateAcl < ActiveRecord::Migration[5.2]
  def change
    create_table :acls do |t|
      t.belongs_to :teacher, foreign_key: true
      t.boolean :enabled, default: true
      t.string :reason

      t.timestamps
    end
  end
end
