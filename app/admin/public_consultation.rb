ActiveAdmin.register PublicConsultation do
  permit_params :title,
                :segment_id,
                :enabled,
                :description,
                :cover_image,
                {documents: []},
                :initial_date,
                :final_date,


  config.filters = true

  collection_action :csv_export_answers, method: :get do
    survey_form_ids = SurveyForm.where(public_consultation_id: params["id"]).map(&:id)
    survey_form_answer_ids = SurveyFormAnswer.where(survey_form_id: survey_form_ids).map(&:id)
    answers = Answer.where(survey_form_answer_id: survey_form_answer_ids)

    csv_string = CSV.generate do |csv|
      csv << ['Professor', 'DRE', 'Questionário', 'Questão', 'Comentário', 'Avaliação']
      answers.each do |answer|
        csv << [
          answer.teacher.user.name,
          answer.teacher.user.dre,
          answer.survey_form_answer.survey_form.title,
          answer.survey_form_content_block.title,
          answer.comment,
          answer.rating
        ]
      end
    end
    send_data csv_string
  end

  collection_action :xls_export_answers, method: :get do
    survey_form_ids = SurveyForm.where(public_consultation_id: params["id"]).map(&:id)
    survey_form_answer_ids = SurveyFormAnswer.where(survey_form_id: survey_form_ids).map(&:id)
    @answers = Answer.where(survey_form_answer_id: survey_form_answer_ids)
  end


  action_item :new, only: :show do
    link_to t('active_admin.new_model', model: SurveyForm.model_name.human),
            new_admin_public_consultation_survey_form_path(public_consultation)
  end

  action_item :csv_export_answers, only: :show do
    link_to "Exportar respostas em CSV", "/admin/public_consultations/csv_export_answers?id=#{public_consultation.id}"
  end

  action_item :xls_export_answers, only: :show do
    link_to "Exportar respostas em XLS", "/admin/public_consultations/xls_export_answers.xls?id=#{public_consultation.id}"
  end

  controller do
    def destroy
      @public_consultation = PublicConsultation.find(params[:id])
      flash[:error] = @public_consultation.errors.full_messages.join(',') unless @public_consultation.destroy
      redirect_to action: :index
    end
  end

  form do |f|
    render 'form', f: f, public_consultation: public_consultation
  end

  index do
    selectable_column
    column :id
    column :segment
    column :title
    column :description
    column :cover_image do |obj|
      image_tag(
      "/assets/#{obj.cover_image_identifier}",
      style: "max-width: 138px; min-height: 180px;"
      ) if obj.cover_image_identifier.present?
    end
    column :documents do |obj|
      obj.documents_identifiers.map.with_index do |file, index|
        link_to("documento #{index + 1}", "/assets/#{file}")
      end.join(' ').html_safe
    end
    column :initial_date  do |obj|
      obj.initial_date.strftime("%d/%m/%Y")
    end
    column :final_date  do |obj|
      obj.final_date.strftime("%d/%m/%Y")
    end
    actions
  end

  show do
    render 'show', context: self
  end

  csv force_quotes: true, col_sep: ';', column_names: true do
    column :title
    column :description
    column :segment do |public_consultation|
      public_consultation.segment.name
    end
    column :initial_date do |public_consultation|
      public_consultation.initial_date.strftime("%d/%m/%Y")
    end
    column :final_date do |public_consultation|
      public_consultation.final_date.strftime("%d/%m/%Y")
    end
    column :created_at do |public_consultation|
      public_consultation.created_at.strftime("%d/%m/%Y")
    end
  end

  xls(
    i18n_scope: [:activerecord, :attributes, :public_consultation],
    header_format: { weight: :bold, color: :blue }
  ) do
    whitelist

    column :title
    column :description
    column :segment do |public_consultation|
      public_consultation.segment.name
    end
    column :initial_date do |public_consultation|
      public_consultation.initial_date.strftime("%d/%m/%Y")
    end
    column :final_date do |public_consultation|
      public_consultation.final_date.strftime("%d/%m/%Y")
    end
    column :created_at do |public_consultation|
      public_consultation.created_at.strftime("%d/%m/%Y")
    end
  end
end
