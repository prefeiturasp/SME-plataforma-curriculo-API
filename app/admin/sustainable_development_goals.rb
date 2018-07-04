ActiveAdmin.register SustainableDevelopmentGoal do
  permit_params :sequence,
                :name,
                :description,
                :goals,
                :icon,
                :sub_icon,
                :color,
                goals_attributes: %i[id description _destroy _create _update]

  config.filters = false
  config.sort_order = 'sequence_asc'

  index do
    selectable_column
    column :icon do |i|
      image_tag variant_url(i.icon, :icon) if i.icon.attached?
    end
    column :sub_icon do |i|
      image_tag variant_url(i.sub_icon, :icon) if i.sub_icon.attached?
    end
    column :name
    column :description
    column :color do |sdg|
      raw "<div class='pick_color'>#{sdg.color}</div>"
    end
    actions
  end

  show do
    attributes_table do
      row :sequence
      row :name
      row :description
      row :color do |sdg|
        raw "<div class='pick_color'>#{sdg.color}</div>"
      end
      row :icon do |i|
        image_tag url_for(i.icon) if i.icon.attached?
      end
      row :sub_icon do |i|
        image_tag url_for(i.sub_icon) if i.sub_icon.attached?
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
      f.input :sub_icon, required: true, as: :file
      f.input :sequence,
        as: :select,
        collection: sequence_options(SustainableDevelopmentGoal),
        selected: sustainable_development_goal.sequence.present? ? sustainable_development_goal.sequence : sequence_options(KnowledgeMatrix).last
      f.input :name
      f.input :description
      f.input :color, as: :color

      f.has_many :goals do |c|
        c.input :description
      end
    end
    f.actions
  end
end
