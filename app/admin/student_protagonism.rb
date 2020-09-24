ActiveAdmin.register StudentProtagonism do
  permit_params :title, :description, :sequence
  config.sort_order = 'sequence_asc'

  config.filters = true

  filter :title
  filter :description
  filter :created_at

  index do
    selectable_column
    column :sequence
    column :title
    column :description
    column :created_at
    column :updated_at

    actions
  end

  form do |f|
    f.inputs do
      f.input :title
      f.input :description
      f.input :sequence,
              as: :select,
              collection: sequence_options(StudentProtagonism),
              selected: student_protagonism.sequence.present? ? student_protagonism.sequence : sequence_options(StudentProtagonism).last
    end
    f.actions
  end

  show do
    attributes_table do
      row :id
      row :sequence
      row :title
      row :description
    end
  end
end
