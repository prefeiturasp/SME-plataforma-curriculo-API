class AddColorToSurveyForms < ActiveRecord::Migration[5.2]
  def change
    add_column :survey_forms, :color, :string
  end
end
