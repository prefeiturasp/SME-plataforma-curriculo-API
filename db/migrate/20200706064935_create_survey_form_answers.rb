class CreateSurveyFormAnswers < ActiveRecord::Migration[5.2]
  def change
    create_table :survey_form_answers do |t|
      t.boolean :anonymous
      t.boolean :finished

      t.belongs_to :survey_form, foreign_key: true
      t.belongs_to :teacher, foreign_key: true
    end
  end
end
