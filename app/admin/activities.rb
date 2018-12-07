ActiveAdmin.register Activity do
  belongs_to :activity_sequence

  action_item :back, only: %i[show edit] do
    link_to t('active_admin.back_to_model', model: ActivitySequence.model_name.human),
            admin_activity_sequence_path(activity.activity_sequence)
  end

  before_action :set_activity_content_block, only: %i[ create update]

  action_item :new, only: :show do
    link_to t('active_admin.new_model', model: activity.model_name.human),
            new_admin_activity_sequence_activity_path(activity.activity_sequence)

    link_to t('helpers.links.preview'), activity_preview_path(activity_sequence.slug, activity.slug), target: :_blank
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
                learning_objective_ids: [],
                activity_content_blocks_attributes: %i[id content_type content_block_id content _destroy]

  controller do
    def set_activity_content_block
      return unless params[:activity][:activity_content_blocks_attributes]
      Rails.logger.debug("*"*80)
      Rails.logger.debug(params[:activity][:activity_content_blocks_attributes])
      Rails.logger.debug("*"*80)

      new_hash = {}
      params[:activity][:activity_content_blocks_attributes].each do |k, v|
        # {"0"=>{"content_type"=>"to_teacher", "content_block_id"=>"2", "body"=>"asdf"},
        hash = {}
        activity_content_block_id = v.delete('id').to_i #always delete id

        hash = {
          content_block_id: v.delete('content_block_id').to_i,
          _destroy: v.delete('_destroy').to_i,
          content: v.to_json
        }

        hash.merge!(id: activity_content_block_id) unless activity_content_block_id.zero?
        new_hash.merge!("#{k}" => hash)
      end
      params[:activity][:activity_content_blocks_attributes] = new_hash

      Rails.logger.debug("n"*80)
      Rails.logger.debug(params[:activity][:activity_content_blocks_attributes])
      Rails.logger.debug("n"*80)
    end
  end

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
