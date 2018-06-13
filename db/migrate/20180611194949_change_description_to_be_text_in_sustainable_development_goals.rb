class ChangeDescriptionToBeTextInSustainableDevelopmentGoals < ActiveRecord::Migration[5.2]
  def change
    change_column :sustainable_development_goals, :description,  :text
  end
end
