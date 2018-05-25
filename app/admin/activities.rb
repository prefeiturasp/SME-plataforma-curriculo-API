ActiveAdmin.register Activity do
  permit_params :sequence,
                :title,
                :estimated_time,
                :content,
                :activity_sequence_id,
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
    attributes_table do
      row :sequence
      row :title
      row :estimated_time
      row :activity_sequence
      row :content do |activity|
        raw(activity.content)
      end
      row :created_at
      row :updated_at
    end
  end
end
