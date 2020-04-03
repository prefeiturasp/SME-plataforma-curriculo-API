ActiveAdmin.register AnswerBook do
  permit_params :name,
                :cover_image,
                :book_file,
                :level,
                :year,
                :curricular_component_id


  config.filters = true

  controller do
    def destroy
      @answer_book = AnswerBook.find(params[:id])
      flash[:error] = @answer_book.errors.full_messages.join(',') unless @answer_book.destroy
      redirect_to action: :index
    end
  end

  form do |f|
    f.inputs do
      f.input :curricular_component, required: true
      f.input :name, required: true
      f.input :year, required: true
      f.input :level, label: 'Segmento', as: :select, collection: AnswerBook::EDUCATION_LEVEL
      f.input :cover_image, required: true, as: :file
      f.input :book_file, required: true, as: :file
    end
    f.actions
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
    column :curricular_component
    column :name
    column :year
    column :level do |obj|
      AnswerBook::SEGMENTOS.select { |k,v| k ==  obj.level.to_sym }[obj.level.to_sym]
    end
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
      row :year
      row :level do |obj|
        AnswerBook::SEGMENTOS.select { |k,v| k ==  obj.level.to_sym }[obj.level.to_sym]
      end
      row :cover_image do |obj|
        image_tag(
          "/assets/#{obj.cover_image_identifier}",
          style: "max-width: 100%"
        ) if obj.cover_image_identifier.present?
      end
      row :book_file do |obj|
        link_to(
          "Caderno Resposta de #{obj.curricular_component.name}",
          "/assets/#{obj.book_file_identifier}"
        ) if obj.book_file_identifier.present?
      end
      row :curricular_component
     end
  end
end
