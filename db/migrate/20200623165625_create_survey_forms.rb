class CreateSurveyForms < ActiveRecord::Migration[5.2]
  def change
    create_table :survey_forms do |t|
      t.string :title
      t.string :description
      t.integer :sequence
      t.jsonb :content
      t.belongs_to :public_consultation, foreign_key: true

      t.timestamps
    end
  end
end
