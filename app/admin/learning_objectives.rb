ActiveAdmin.register LearningObjective do
  config.sort_order = 'code_asc'
  permit_params :description,
                :code,
                :curricular_component_id,
                :segment_id,
                :stage_id,
                :year_id,
                sustainable_development_goal_ids: [],
                axis_ids: []

  config.filters = true

  filter :curricular_component
  filter :created_at

  collection_action :change_axes, method: :get do
    render json: {}, status: :unauthorized && return unless current_user.admin?

    axes = Axis.where(
      curricular_component_id: params[:curricular_component_id]
    )

    data = axes.pluck(:id, :description)
    render json: data
  end

  form do |f|
    f.inputs do
      f.input :segment, required: true
      f.input :stage,
              required: true,
              collection: learning_objective.segment.present? ? stage_collection(learning_objective.segment.id) : [t('Selecione um segmento'), nil]
      f.input :stage, collection: [], required: true
      f.input :year, collection: [], required: true
      f.input :description
      f.input :curricular_component
      f.input :code
      f.input :sustainable_development_goals,
              as: :check_boxes,
              collection: sustainable_development_goals_collection,
              input_html: { multiple: true }
      f.input :axes,
              as: :check_boxes,
              collection: axes_collection_from_learning_objectives(learning_objective),
              input_html: {
                multiple: true,
                disabled: true
              }
    end
    f.actions
  end

  index do
    selectable_column
    column :code
    column :segment
    column :stage
    column :year
    column :description
    column :curricular_component
    column :created_at
    column :updated_at

    actions
  end

  show do
    attributes_table do
      row :code
      row :segment
      row :stage
      row :year
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

    panel I18n.t('activerecord.models.axis', count: 2) do
      table_for learning_objective.axes do
        column :description
      end
    end
  end

  xls(
    i18n_scope: [:activerecord, :attributes, :learning_objective],
    header_format: { weight: :bold, color: :blue }
  ) do
    whitelist

    column :code
    column :segment
    column :stage
    column :year
    column :description
    column :curricular_component do |learning_objective|
      learning_objective.curricular_component.name
    end
    column :created_at
  end
end
