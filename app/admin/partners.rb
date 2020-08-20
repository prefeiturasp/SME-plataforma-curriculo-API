ActiveAdmin.register Partner do
  permit_params :name,
                :description,
                complement_books_attributes: [
                  :id,
                  :name,
                  :cover_image,
                  :book_file,
                  :partner_id,
                  :author,
                  :_destroy,
                  complement_book_links_attributes: [
                    :id,
                    :complement_book_id,
                    :link
                  ]
                ]


  config.filters = true

  filter :name
  filter :description
  filter :created_at

  controller do
    def destroy
      @partner = Partner.find(params[:id])
      flash[:error] = @partner.errors.full_messages.join(',') unless @partner.destroy
      redirect_to action: :index
    end
  end

  form do |f|
    render 'form', f: f, partner: partner
  end

  index do
    render 'index', context: self
  end

  show do
    render 'show', context: self
  end
end
