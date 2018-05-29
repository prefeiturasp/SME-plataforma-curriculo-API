ActiveAdmin.register Axis do
  permit_params :description,
                :year,
                :curricular_component_id

  config.filters = false

  form do |f|
    f.inputs do
      f.input :year, as: :select, collection: human_attribute_years
      f.input :description
      f.input :curricular_component
    end
    f.actions
  end

  index do
    selectable_column
    column :id
    column :description
    column :year do |axes|
      Axis.human_enum_name(:year, axes.year, true)
    end
    column :curricular_component
    actions
  end

  show do
    attributes_table do
      row :id
      row :year do |axis|
        Axis.human_enum_name(:year, axis.year, true)
      end
      row :description
      row :curricular_component
      row :created_at
      row :updated_at
    end
  end
end
