class AssignDefaultSequenceContentBlocks < ActiveRecord::Migration[5.2]
  def up
    Activity.all.each do |activity|
      activity.activity_content_blocks.each.with_index(1) do |content_block, sequence|
        content_block.update(sequence: sequence) unless content_block.sequence
      end
    end
  end

  def down
    # irreversible migration
  end
end
