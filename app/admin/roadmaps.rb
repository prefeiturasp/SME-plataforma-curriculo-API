ActiveAdmin.register Roadmap do
  permit_params :description,
                :title,
                :status

  config.filters = false

  form do |f|
    f.inputs do
      f.input :status, as: :select, collection: human_attribute_roadmap_statuses
      f.input :title
      f.input :description
    end
    f.actions
  end

  index do
    selectable_column
    column :id
    column :title
    column :description
    column :status do |roadmap|
      Roadmap.human_enum_name(:status, roadmap.status)
    end
    actions
  end

  show do
    attributes_table do
      row :id
      row :title
      row :description
      row :status do |roadmap|
        Roadmap.human_enum_name(:status, roadmap.status)
      end
      row :created_at
      row :updated_at
    end
  end
end
