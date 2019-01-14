ActiveAdmin.register Rating do
  permit_params :id,
                :sequence,
                :description,
                :enable

  config.filters = false
  config.sort_order = 'sequence_asc'

  form do |f|
    f.inputs do
      f.input :enable, as: :hidden, input_html: { value: true }
      f.input :sequence,
              as: :select,
              collection: sequence_options(Rating),
              selected: rating.sequence.present? ? rating.sequence : sequence_options(Rating).last,
              include_blank: false,
              allow_blank: false
      f.input :description
    end
    f.actions
  end

  show do
    attributes_table do
      row :sequence
      row :description
      row :created_at
      row :updated_at
    end
  end

  index do
    selectable_column
    column :sequence
    column :description
    column :enable

    actions
  end
end
