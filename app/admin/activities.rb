ActiveAdmin.register Activity do
  permit_params :sequence,
                :title,
                :estimated_time,
                :content,
                :activity_sequence_id,
                :image,
                activity_type_ids: []

  index do
    selectable_column
    column :sequence
    column :title
    column :estimated_time
    column :activity_sequence
    actions
  end

  form do |f|
    render 'form', f: f
  end

  show do
    render 'show', context: self
  end
end
