class AddStageRefToLearningObjective < ActiveRecord::Migration[5.2]
  def change
    add_reference :learning_objectives, :stage, index: true
  end
end
