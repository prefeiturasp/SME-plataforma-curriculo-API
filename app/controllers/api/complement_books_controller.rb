module Api
  class ComplementBooksController < ApiController
    def index
      @complement_books = ComplementBook.includes(:curricular_component).all.order(
        "curricular_components.name asc"
      )

      render :index
    end

    private

    def complement_book_params
      params.require(:complement_book).permit(
        :name,
        :description,
        :author,
        :cover_image,
        :book_file,
        :curricular_component_id
      )
    end
  end
end
