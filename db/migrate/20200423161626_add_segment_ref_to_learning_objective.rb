class AddSegmentRefToLearningObjective < ActiveRecord::Migration[5.2]
  def change
    add_reference :learning_objectives, :segment, index: true
  end
end
