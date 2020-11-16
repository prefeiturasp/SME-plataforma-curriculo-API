class CreateJoinTableProjectSustainableDevelopmentGoal < ActiveRecord::Migration[5.2]
  def change
    create_join_table :projects, :sustainable_development_goals
  end
end
