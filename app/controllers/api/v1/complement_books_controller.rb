module Api
  module V1
    class ComplementBooksController < ApiController
      before_action :set_complement_book, only: %i[show update destroy]

      # GET /v1/complement_books
      def index
        @complement_books = ComplementBook.all

        render json: @complement_books
      end

      # GET /v1/complement_books/1
      def show
        render json: @complement_book
      end

      # POST /v1/complement_books
      def create
        @complement_book = ComplementBook.new(complement_book_params)

        if @complement_book.save
          render json: @complement_book, status: :created
        else
          render json: @complement_book.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /v1/complement_books/1
      def update
        if @complement_book.update(complement_book_params)
          render json: @complement_book
        else
          render json: @complement_book.errors, status: :unprocessable_entity
        end
      end

      # DELETE /v1/complement_books/1
      def destroy
        @complement_book.destroy
      end

      private

      # Use callbacks to share common setup or constraints between actions.
      def set_complement_book
        @complement_book = ComplementBook.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
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
end
