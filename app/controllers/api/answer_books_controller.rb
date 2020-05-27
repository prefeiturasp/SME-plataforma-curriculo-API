module Api
  class AnswerBooksController < ApiController
    def index
      if params[:stage_id]
        @answer_books = AnswerBook.includes(:curricular_component).where(stage_id: params[:stage_id]).order(
          "curricular_components.name asc"
        )
      else
        @answer_books = AnswerBook.all
      end
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
