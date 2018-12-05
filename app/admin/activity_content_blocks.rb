ActiveAdmin.register ActivityContentBlock do
  belongs_to :activity

  permit_params :activity_id,
                :content_block_id,
                :content

  config.filters = false

  form do |f|
    f.inputs do
      f.input :content_block, as: :select, collection: human_attribute_content_blocks
      # render 'to_professor', f: f
      render partial: 'to_professor', locals: { f: f }
    end
    f.actions
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
