ActiveAdmin.register ActivityContentBlock do
  belongs_to :activity

  permit_params :activity_id,
                :content_block_id,
                :content

  config.filters = false

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
