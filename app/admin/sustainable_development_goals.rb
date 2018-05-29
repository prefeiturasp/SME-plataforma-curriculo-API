ActiveAdmin.register SustainableDevelopmentGoal do
  permit_params :sequence,
                :name,
                :description,
                :goals,
                :icon,
                goals_attributes: %i[id description _destroy _create _update]

  config.filters = false
  config.sort_order = 'sequence_asc'

  index do
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
      panel I18n.t('activerecord.attributes.sustainable_development_goal.goals', count: 2) do
        table_for sustainable_development_goal.goals do
          column :description
        end
      end
    end
  end

  form do |f|
    f.inputs do
      f.input :icon, required: true, as: :file
      f.input :sequence
      f.input :name
      f.input :description

      f.has_many :goals do |c|
        c.input :description
      end
    end
    f.actions
  end
end