ActiveAdmin.register ComplementBook do
  permit_params :name,
                :cover_image,
                :book_file,
                :curricular_component_id,
                :description,
                :author


  config.filters = true

  filter :name
  filter :description
  filter :author
  filter :curricular_component
  filter :created_at

  controller do
    def destroy
      @complement_book = ComplementBook.find(params[:id])
      flash[:error] = @complement_book.errors.full_messages.join(',') unless @complement_book.destroy
      redirect_to action: :index
    end
  end

  form do |f|
    render 'form', f: f, complement_book: complement_book
  end

  index do
    selectable_column
    column :id
    column :cover_image do |obj|
      image_tag(
      "/assets/#{obj.cover_image_identifier}",
      style: "max-width: 138px; min-height: 180px;"
      ) if obj.cover_image_identifier.present?
    end
    column :name
    column :description
    column :author
    column :curricular_component
    column :book_file do |obj|
      link_to(
        "Caderno Resposta de #{obj.curricular_component.name}",
        "/assets/#{obj.book_file_identifier}"
      ) if obj.book_file_identifier.present?
    end
    actions
  end

  show do
    attributes_table do
      row :id
      row :name
      row :description
      row :author
      row :curricular_component
      row :cover_image do |obj|
        image_tag(
          "/assets/#{obj.cover_image_identifier}",
          style: "max-width: 100%"
        ) if obj.cover_image_identifier.present?
      end
      row :book_file do |obj|
        link_to(
          "Caderno Complementar de #{obj.curricular_component.name}",
          "/assets/#{obj.book_file_identifier}"
        ) if obj.book_file_identifier.present?
      end
     end
  end
end
