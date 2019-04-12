ActiveAdmin.register Challenge do
#  action_item :back, only: %i[show edit] do
#    link_to t('active_admin.back_to_model', model: ActivitySequence.model_name.human),
#            admin_activity_sequence_path(activity.activity_sequence)
#  end

  before_action :set_challenge_content_block, only: %i[create update]

#  action_item :new, only: :show do
#    link_to t('active_admin.new_model', model: activity.model_name.human),
#            new_admin_activity_sequence_activity_path(activity.activity_sequence)
#    link_to t('helpers.links.preview'), activity_preview_path(activity_sequence.slug, activity.slug), target: :_blank
#  end

  permit_params :title,
                :status,
                :slug,
                :content,
                :image,
                curricular_component_ids: [],
                learning_objective_ids: [],
                challenge_content_blocks_attributes: [
                  :id,
                  :content_type,
                  :content_block_id,
                  :sequence,
                  :content,
                  :_destroy,
                  images_attributes: [
                    :id,
                    :subtitle,
                    :file,
                    :_destroy
                  ]
                ]

  controller do
    def set_activity_content_block
      return unless params[:challenge][:challenge_content_blocks_attributes]
      new_hash = {}
      params[:challenge][:challenge_content_blocks_attributes].each do |k, v|
        hash = {}
        challenge_content_block_id = v.delete('id').to_i #always delete id
        sequence = v.delete('sequence').to_i
        images_attributes = v.delete('images_attributes')
        icon_url = assign_icon_url(v)
        v['icon_url'] = icon_url if icon_url.present?

        hash = {
          content_block_id: v.delete('content_block_id').to_i,
          _destroy: v.delete('_destroy').to_i,
          content: v.to_json
        }

        hash.merge!(id: challenge_content_block_id) unless challenge_content_block_id.zero?
        hash.merge!(images_attributes: images_attributes) if images_attributes.present?
        hash[:sequence] = sequence
        new_hash.merge!("#{k}" => hash)
      end
      params[:challenge][:challenge_content_blocks_attributes] = new_hash
    end


    def assign_icon_url content_hash
      return nil if content_hash["title"].blank? || !content_hash.key?('icon_url')
      icon_source = "/images/pre_defined_exercises/#{content_hash['title'].parameterize(separator: '_') }.svg"
      icon_url = ActionController::Base.helpers.image_path icon_source

      URI.join root_url, icon_url
    end

    def create
      super do |format|
        format.html { redirect_to collection_url and return if resource.valid? }
        format.json { render json: resource }
      end
    end

    def update
      super do |format|
        format.html { redirect_to collection_url and return if resource.valid? }
        format.json { render json: resource }
      end
    end
  end

  index do
    render 'index', context: self
  end

  form do |f|
    render 'form', f: f, challenge: challenge
  end

  show do
    render 'show', context: self
  end
end
