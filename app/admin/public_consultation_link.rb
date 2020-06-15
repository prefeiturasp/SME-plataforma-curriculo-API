ActiveAdmin.register PublicConsultationLink do
  belongs_to :public_consultation

  permit_params :public_consultation,
                :title,
                :link
  controller do
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
    render 'form', f: f, public_consultation_link: public_consultation_link
  end

  show do
    render 'show', context: self
  end
end
