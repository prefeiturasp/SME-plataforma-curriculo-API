class ChangeYearFromLearningObjectives < ActiveRecord::Migration[5.2]
  def change
    remove_column :learning_objectives, :year
    add_reference :learning_objectives, :year, index: true
  end
end
