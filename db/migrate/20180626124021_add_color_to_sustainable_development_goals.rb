class AddColorToSustainableDevelopmentGoals < ActiveRecord::Migration[5.2]
  def change
    add_column :sustainable_development_goals, :color, :string
  end
end
