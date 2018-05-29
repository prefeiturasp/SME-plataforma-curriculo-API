ActiveAdmin.register ActivitySequence do
  action_item :new, only: :show do
    link_to t('active_admin.new_model', model: Activity.model_name.human),
            new_admin_activity_sequence_activity_path(activity_sequence)
  end

  permit_params :title,
                :year,
                :presentation_text,
                :books,
                :estimated_time,
                :status,
                :image,
                :main_curricular_component_id,
                curricular_component_ids: [],
                sustainable_development_goal_ids: [],
                knowledge_matrix_ids: [],
                learning_objective_ids: []

  form do |f|
    f.inputs do
      f.input :status
      f.input :title
      f.input :image, required: true, as: :file
      f.input :presentation_text
      f.input :main_curricular_component
      f.input :year, as: :select, collection: human_attribute_years
      f.input :curricular_components, as: :select, input_html: { multiple: true }
      f.input :books
      f.input :estimated_time
      f.input :sustainable_development_goals, as: :select, input_html: { multiple: true }
      f.input :knowledge_matrices, as: :select, input_html: { multiple: true }
      f.input :learning_objectives,
              as: :select,
              collection: learning_objectives_collection,
              input_html: { multiple: true }
    end
    f.actions
  end

  index do
    selectable_column
    column :id
    column :title
    column :presentation_text
    column :estimated_time
    column :year do |activity_sequence|
      ActivitySequence.human_enum_name(:year, activity_sequence.year, true)
    end
    column :main_curricular_component
    column :status do |activity_sequence|
      ActivitySequence.human_enum_name(:status, activity_sequence.status)
    end
    actions
  end

  show do
    render 'show', context: self
  end
end
