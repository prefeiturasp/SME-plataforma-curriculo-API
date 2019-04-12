class AddPolymorphismToImages < ActiveRecord::Migration[5.2]
  def up
    add_column :images, :imageable_id, :integer
    add_column :images, :imageable_type, :string

    add_index :images, [:imageable_id, :imageable_type]

    # update all existing images
    Image.pluck(:id, :activity_content_block_id).each do |id, assoc_id|
      execute "UPDATE images SET imageable_id = #{assoc_id}, imageable_type = 'ActivityContentBlock' WHERE id = #{id}"
    end

    remove_reference :images, :activity_content_block, index: true, foreign_key: true
  end

  def down
    add_reference :images, :activity_content_block, foreign_key: true

    Image
      .where(imageable_type: 'ActivityContentBlock')
      .puck(:id, :imageable_id).each do |id, assoc_id|
      execute "UPDATE images SET activity_content_block_id = #{assoc_id} WHERE id = #{id}"
    end

    remove_column :images, :imageable_id
    remove_column :images, :imageable_type

    remove_index :images, [:imageable_id, :imageable_type]
  end
end
