class MigrateActivityContentToActivityContentBlocks < ActiveRecord::Migration[5.2]
  def up
    content_block = ContentBlock.find_by(content_type: :free_text)
    Activity.all.each do |activity|
      next if activity.content.blank?
      act_content_block = ActivityContentBlock.new(
                            content_block_id: content_block.id,
                            activity_id: activity.id,
                            sequence: 1)

      act_content_block.body = activity.content
      act_content_block.save
    end
  end

  def def down 
    # irreversible migration
  end
end
