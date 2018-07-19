ActiveAdmin.register Axis do
  permit_params :description,
                :curricular_component_id

  config.filters = false

  form do |f|
    f.inputs do
      f.input :description
      f.input :curricular_component
    end
    f.actions
  end

  index do
    selectable_column
    column :id
    column :description
    column :curricular_component
    actions
  end

  show do
    attributes_table do
      row :id
      row :description
      row :curricular_component
      row :created_at
      row :updated_at
    end
  end
end
