module Api
  class AnswerBooksController < ApiController
    def index
      @answer_books = AnswerBook.order_by_component_name(params[:segment_name])

      render :index
    end

    private

    def answer_book_params
      params.require(:answer_book).permit(
        :name,
        :cover_image,
        :book_file,
        :year,
        :segment_name,
        :segment_id,
        :stage_id,
        :curricular_component_id
      )
    end
  end
end
