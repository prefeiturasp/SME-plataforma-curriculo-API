ActiveAdmin.register PublicConsultation do
  permit_params :title,
                :segment_id,
                :description,
                :cover_image,
                {documents: []},
                :initial_date,
                :final_date,


  config.filters = true

  action_item :new, only: :show do
    link_to t('active_admin.new_model', model: PublicConsultationLink.model_name.human),
            new_admin_public_consultation_public_consultation_link_path(public_consultation)
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
    column :public_consultation_links do |public_consultation|
      public_consultation.public_consultation_links.map(&:link).join(" ")
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
    column :public_consultation_links do |public_consultation|
      public_consultation.public_consultation_links.map(&:link).join(" ")
    end
    column :created_at do |public_consultation|
      public_consultation.created_at.strftime("%d/%m/%Y")
    end
  end
end
