ActiveAdmin.register ActivityContentBlock do
  belongs_to :activity

  permit_params :activity_id,
                :content_block_id,
                :content

  config.filters = false

  collection_action :set_order, method: :post do
    activity = Activity.find_by(id: params[:activity_id])
    activity_content_block_ids = params[:activity_content_block_ids].reject(&:empty?)
    activity_content_block_ids.each.with_index(1) do |activity_content_block_id, sequence|
      activity_content_block = activity.activity_content_blocks.find_by(id: activity_content_block_id)
      next unless activity_content_block
      activity_content_block.sequence = sequence
      activity_content_block.save
    end

    render json: {}
  end

  index do
    selectable_column
    column :content_block
    actions
  end

  show do
    attributes_table do
      row :content_block
    end
  end
end
