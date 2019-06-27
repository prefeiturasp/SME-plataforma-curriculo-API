ActiveAdmin.register ActivitySequence do
  config.sort_order = 'title_asc'
  config.filters = true

  filter :title
  filter :year
  filter :presentation_text
  filter :main_curricular_component
  filter :knowledge_matrices
  filter :sustainable_development_goals

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
                :keywords,
                :main_curricular_component_id,
                knowledge_matrix_ids: [],
                learning_objective_ids: []

  controller do
    def find_resource
      scoped_collection.friendly.find(params[:id])
    end
  end

  collection_action :change_learning_objectives, method: :get do
    @learning_objectives = LearningObjective.where(
      year: params[:year],
      curricular_component_id: params[:main_curricular_component_id]
    )
    data = @learning_objectives.pluck(:id, :code, :description)

    render json: data
  end

  collection_action :delete_image_attachment, method: :delete do
    attachment = ActiveStorage::Attachment.find_by(id: params[:id])
    if attachment&.purge
      head :no_content
    else
      head :unprocessable_entity
    end
  end

  form do |f|
    render 'form', f: f, activity_sequence: activity_sequence
  end

  index do
    selectable_column
    column :id
    column :title
    column :presentation_text do |activity_sequence|
      truncate activity_sequence.presentation_text, omision: "...", length: 100
    end
    column :estimated_time
    column :year do |activity_sequence|
      ActivitySequence.human_enum_name(:year, activity_sequence.year, true)
    end
    column :main_curricular_component
    column :status do |activity_sequence|
      ActivitySequence.human_enum_name(:status, activity_sequence.status)
    end
    column do |activity_sequence|
      span link_to t('helpers.links.show'), admin_activity_sequence_path(activity_sequence)
      span link_to t('helpers.links.preview'), activity_sequence_preview_path(activity_sequence.slug), target: :_blank
      span link_to t('helpers.links.edit'), edit_admin_activity_sequence_path(activity_sequence)
      span link_to t('helpers.links.destroy'),
                   admin_activity_sequence_path(activity_sequence),
                   method: :delete,
                   data: { confirm: t('active_admin.delete_confirmation') }
    end
  end

  show do
    render 'show', context: self
  end

  csv do
    column :title
    column :presentation_text
    column :estimated_time
    column :year do |activity_sequence|
      ActivitySequence.human_enum_name(:year, activity_sequence.year, true)
    end
    column :main_curricular_component do |as|
      as.main_curricular_component.name
    end
    column :learning_objectives do |as|
      as.learning_objectives.pluck(:code).join ', '
    end
    column :axes do |as|
      as.axes.pluck(:code).join ', '
    end
    column :sustainable_development_goals do |as|
      as.sustainable_development_goals.pluck(:name).join ', '
    end
    column :knowledge_matrices do |as|
      as.knowledge_matrices.pluck(:title).join ', '
    end
    column :activities do |as|
      as.activities.count
    end
  end

  xls(
    i18n_scope: [:activerecord, :attributes, :activity_sequence],
    header_format: { weight: :bold, color: :blue }
  ) do
    whitelist

    column :title
    column :presentation_text
    column :estimated_time
    column :year do |activity_sequence|
      ActivitySequence.human_enum_name(:year, activity_sequence.year, true)
    end
    column :main_curricular_component do |as|
      as.main_curricular_component.name
    end
    column :learning_objectives do |as|
      as.learning_objectives.pluck(:code).join ', '
    end
    column :axes do |as|
      as.axes.pluck(:code).join ', '
    end
    column :sustainable_development_goals do |as|
      as.sustainable_development_goals.pluck(:name).join ', '
    end
    column :knowledge_matrices do |as|
      as.knowledge_matrices.pluck(:title).join ', '
    end
    column :activities do |as|
      as.activities.count
    end
  end
end
