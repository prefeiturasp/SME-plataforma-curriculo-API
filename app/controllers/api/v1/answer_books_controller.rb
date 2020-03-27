module Api
  module V1
    class AnswerBooksController < ApiController
      before_action :set_answer_book, only: %i[show update destroy]

      # GET /answer_books
      def index
        @answer_books = AnswerBook.all

        render json: @answer_books
      end

      # GET /answer_books/1
      def show
        render json: @answer_book
      end

      # POST /answer_books
      def create
        @answer_book = AnswerBook.new(answer_book_params)

        if @answer_book.save
          render json: @answer_book, status: :created
        else
          render json: @answer_book.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /answer_books/1
      def update
        if @answer_book.update(answer_book_params)
          render json: @answer_book
        else
          render json: @answer_book.errors, status: :unprocessable_entity
        end
      end

      # DELETE /answer_books/1
      def destroy
        @answer_book.destroy
      end

      private

      # Use callbacks to share common setup or constraints between actions.
      def set_answer_book
        @answer_book = AnswerBook.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def answer_book_params
        params.require(:answer_book).permit(
          :name,
          :cover_image,
          :book_file,
          :year,
          :level,
          :curricular_component_id
        )
      end
    end
  end
end
