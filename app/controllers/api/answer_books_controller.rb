module Api
  class AnswerBooksController < ApiController
    before_action :authenticate_api_user!

    def index
      @answer_books = AnswerBook.includes(:curricular_component).all.order(
        "curricular_components.name asc"
      )

      render :index
    end

    def book_file
      answer_book = AnswerBook.find(params[:id])
      send_file answer_book.book_file.path
    end

    private

    def answer_book_params
      params.require(:answer_book).permit(
        :name,
        :cover_image,
        :book_file,
        :segment_name,
        :segment_id,
        :stage_id,
        :year_id,
        :curricular_component_id
      )
    end
  end
end
