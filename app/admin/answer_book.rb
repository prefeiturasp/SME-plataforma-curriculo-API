ActiveAdmin.register AnswerBook do
  permit_params :name,
                :cover_image,
                :book_file,
                :curricular_component_id,
                :stage_id,
                :segment_id,
                :year_id


  config.filters = true

  controller do
    def destroy
      @answer_book = AnswerBook.find(params[:id])
      flash[:error] = @answer_book.errors.full_messages.join(',') unless @answer_book.destroy
      redirect_to action: :index
    end
  end

  form do |f|
    render 'form', f: f, answer_book: answer_book
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
    column :curricular_component
    column :segment
    column :stage
    column :year
    column :book_file do |obj|
      link_to 'Download Livro', book_file_api_answer_book_path(obj)
    end
    actions
  end

  show do
    attributes_table do
      row :id
      row :name
      row :curricular_component
      row :segment
      row :stage
      row :year
      row :cover_image do |obj|
        image_tag(
          "/assets/#{obj.cover_image_identifier}",
          style: "max-width: 100%"
        ) if obj.cover_image_identifier.present?
      end
      row :book_file do |obj|
        link_to 'Download Livro', book_file_api_answer_book_path(obj)
      end
     end
  end
end
