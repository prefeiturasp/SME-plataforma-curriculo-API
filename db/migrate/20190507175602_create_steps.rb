class CreateSteps < ActiveRecord::Migration[5.2]
  def change
    create_table :steps do |t|
      t.belongs_to :methodology, foreign_key: true
      t.string     :title
      t.text       :description
    end
  end
end
