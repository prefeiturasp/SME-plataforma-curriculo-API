module Api
  class ComplementBooksController < ApiController
    before_action :authenticate_api_user!
    
    def index
      @complement_books = ComplementBook.all.order(
        "name asc"
      )

      render :index
    end

    def book_file
      complement_book = ComplementBook.find(params[:id])
      send_file complement_book.book_file.path
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
