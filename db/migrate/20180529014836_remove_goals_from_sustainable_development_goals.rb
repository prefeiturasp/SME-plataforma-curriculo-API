class RemoveGoalsFromSustainableDevelopmentGoals < ActiveRecord::Migration[5.2]
  def change
    remove_column :sustainable_development_goals, :goals, :string
  end
end
