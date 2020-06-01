module Api
  class AnswerBooksController < ApiController
    def index
      @answer_books = AnswerBook.includes(:curricular_component).all.order(
        "curricular_components.name asc"
      )

      render :index
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
