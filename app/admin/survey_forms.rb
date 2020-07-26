ActiveAdmin.register SurveyForm do
  belongs_to :public_consultation

  action_item :back, only: %i[show edit] do
    link_to t('active_admin.back_to_model', model: PublicConsultation.model_name.human),
            admin_public_consultation_path(survey_form.public_consultation)
  end

  before_action :set_survey_form_content_block, only: %i[ create update]

  action_item :new, only: :show do
    link_to t('active_admin.new_model', model: survey_form.model_name.human),
            new_admin_public_consultation_survey_form_path(survey_form.public_consultation)
  end

  permit_params :title,
                :description,
                :public_consultation_id,
                :content,
                :sequence,
                survey_form_content_blocks_attributes: [
                  :id,
                  :content_type,
                  :content_block_id,
                  :sequence,
                  :content,
                  :_destroy,
                  :required_rating,
                  :have_rating,
                  :required_comment,
                  :have_comment,
                  :title,
                  images_attributes: [
                    :id,
                    :subtitle,
                    :file,
                    :_destroy
                  ]
                ]

  controller do
    def set_survey_form_content_block
      return unless params[:survey_form][:survey_form_content_blocks_attributes]
      new_hash = {}
      params[:survey_form][:survey_form_content_blocks_attributes].each do |k, v|
        hash = {}
        survey_form_content_block_id = v.delete('id').to_i #always delete id
        sequence = v.delete('sequence').to_i
        images_attributes = v.delete('images_attributes')
        hash = {
          content_block_id: v.delete('content_block_id').to_i,
          _destroy: v.delete('_destroy').to_i,
          content: v.to_json
        }

        hash.merge!(id: survey_form_content_block_id) unless survey_form_content_block_id.zero?
        hash.merge!(images_attributes: images_attributes) if images_attributes.present?
        hash[:sequence] = sequence
        new_hash.merge!("#{k}" => hash)
      end
      params[:survey_form][:survey_form_content_blocks_attributes] = new_hash
    end

    def create
      super do |format|
        format.html { redirect_to collection_url and return if resource.valid? }
        format.json { render json: resource }
      end
    end

    def update
      begin
        super do |format|
          format.html { redirect_to collection_url and return if resource.valid? }
          format.json { render json: resource }
        end
      rescue
        flash[:error] = "Erro ao tentar excluir questão: Já existem respostas relacionadas."
        redirect_to collection_url
      end
    end

    def destroy
      super do |format|
        e = resource.errors.full_messages.to_sentence
        flash[:error] = "Erro ao tentar deletar: #{e}" if e.present?
        flash[:error] ||= "Erro ao tentar deletar: Já existem respostas relacionadas."
        format.html { redirect_to collection_url and return if resource.valid? }
        format.json { render json: resource }
      end
    end
  end

  index do
    render 'index', context: self
  end

  form do |f|
    render 'form', f: f, survey_form: survey_form
  end

  show do
    render 'show', context: self
  end
end
