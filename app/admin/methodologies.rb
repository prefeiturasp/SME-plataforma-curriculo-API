ActiveAdmin.register Challenge do
  before_action :set_content_block, only: %i[create update]

  actions :all, except: [:new]

  permit_params :title,
                :slug,
                :icon,
                :description,
                contents_attributes: [
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
    def set_content_block
      return unless params[:methodology][:contents_attributes]
      new_hash = {}
      params[:methodology][:contents_attributes].each do |k, v|
        hash = {}
        content_block_id  = v.delete('id').to_i
        sequence          = v.delete('sequence').to_i
        images_attributes = v.delete('images_attributes')
        icon_url          = assign_icon_url(v)
        v['icon_url']     = icon_url if icon_url.present?

        hash = {
          content_block_id: v.delete('content_block_id').to_i,
          _destroy:         v.delete('_destroy').to_i,
          content:          v.to_json
        }

        hash.merge!(id: content_block_id) unless content_block_id.zero?
        hash.merge!(images_attributes: images_attributes) if images_attributes.present?
        hash[:sequence] = sequence
        new_hash.merge!("#{k}" => hash)
      end
      params[:methodology][:contents_attributes] = new_hash
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
    render 'form', f: f, methodology: methodology
  end

  show do
    render 'show', context: self
  end
end
