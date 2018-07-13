class DropJoinTableActivitySequenceSustainableDevelopmentGoal < ActiveRecord::Migration[5.2]
  def change
    drop_join_table :activity_sequences, :sustainable_development_goals
  end
end
