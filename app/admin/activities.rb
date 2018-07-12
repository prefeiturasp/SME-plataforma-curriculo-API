ActiveAdmin.register Activity do
  belongs_to :activity_sequence

  action_item :back, only: %i[show edit] do
    link_to t('active_admin.back_to_model', model: ActivitySequence.model_name.human),
            admin_activity_sequence_path(activity.activity_sequence)
  end

  action_item :new, only: :show do
    link_to t('active_admin.new_model', model: activity.model_name.human),
            new_admin_activity_sequence_activity_path(activity.activity_sequence)
  end

  permit_params :sequence,
                :title,
                :slug,
                :estimated_time,
                :content,
                :activity_sequence_id,
                :image,
                :environment,
                activity_type_ids: [],
                curricular_component_ids: [],
                learning_objective_ids: []

  index do
    render 'index', context: self
  end

  form do |f|
    render 'form', f: f, activity: activity
  end

  show do
    render 'show', context: self
  end
end
