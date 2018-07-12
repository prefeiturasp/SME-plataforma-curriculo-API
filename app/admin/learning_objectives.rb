ActiveAdmin.register LearningObjective do
  config.sort_order = 'code_asc'
  permit_params :year,
                :description,
                :code,
                :curricular_component_id,
                sustainable_development_goal_ids: []

  form do |f|
    f.inputs do
      f.input :year, as: :select, collection: human_attribute_years
      f.input :description
      f.input :curricular_component
      f.input :code
      f.input :sustainable_development_goals,
              as: :select,
              collection: sustainable_development_goals_collection,
              input_html: { multiple: true }
    end
    f.actions
  end

  index do
    selectable_column
    column :code
    column :year do |learning_objective|
      LearningObjective.human_enum_name(:year, learning_objective.year, true)
    end
    column :description
    column :curricular_component
    column :created_at
    column :updated_at

    actions
  end

  show do
    attributes_table do
      row :code
      row :year do |learning_objective|
        LearningObjective.human_enum_name(:year, learning_objective.year, true)
      end
      row :description
      row :curricular_component
      row :created_at
      row :updated_at
    end

    panel I18n.t('activerecord.models.sustainable_development_goal', count: 2) do
      table_for learning_objective.sustainable_development_goals do
        column :icon do |i|
          image_tag variant_url(i.icon, :icon) if i.icon.attached?
        end
        column :name
      end
    end
  end
end
