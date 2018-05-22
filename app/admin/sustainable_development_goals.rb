ActiveAdmin.register SustainableDevelopmentGoal do
  permit_params :sequence, :name, :description, :goals, :icon

  config.filters = false

  index do
    config.sort_order = 'sequence DESC'
    selectable_column
    column :icon do |i|
      image_tag url_for(i.icon) if i.icon.attached?
    end
    column :name
    column :description
    actions
  end

  show do
    attributes_table do
      row :sequence
      row :name
      row :description
      row :icon do |i|
        image_tag url_for(i.icon) if i.icon.attached?
      end
      row :goals_raw
    end
  end

  form do |f|
    f.inputs do
      f.input :icon, required: true, as: :file
      f.input :sequence
      f.input :name
      f.input :description
      f.input :goals
    end
    f.actions
  end
end
