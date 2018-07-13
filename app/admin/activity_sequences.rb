ActiveAdmin.register ActivitySequence do
  config.sort_order = 'title_asc'

  action_item :new, only: :show do
    link_to t('helpers.links.preview'), activity_sequence_preview_path(activity_sequence.slug), target: :_blank
  end

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
                knowledge_matrix_ids: [],
                learning_objective_ids: [],
                axis_ids: []

  controller do
    def find_resource
      scoped_collection.friendly.find(params[:id])
    end
  end

  collection_action :change_learning_objectives, method: :get do
    @learning_objectives = LearningObjective.where(curricular_component_id: params[:main_curricular_component_id])
    if @learning_objectives.present?
      render plain: view_context.options_from_collection_for_select(@learning_objectives, :id, :code_and_description)
    else
      render plain: view_context.options_for_select(
        [
          [t('activerecord.errors.messages.none_learning_objectives'), nil]
        ]
      )
    end
  end

  form do |f|
    render 'form', f: f, activity_sequence: activity_sequence
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
    column do |activity_sequence|
      if Rails.env.development?
        span link_to t('helpers.links.show'), admin_activity_sequence_path(activity_sequence)
      else
        span link_to t('helpers.links.show'), activity_sequence_preview_path(activity_sequence.slug), target: :_blank
      end
      span link_to t('helpers.links.edit'),edit_admin_activity_sequence_path(activity_sequence)
      span link_to t('helpers.links.destroy'),
        admin_activity_sequence_path(activity_sequence),
        method: :delete
    end
  end

  show do
    render 'show', context: self
  end
end
