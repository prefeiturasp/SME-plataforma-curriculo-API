module Api
  module V1
    class YearsController < ApiController

      before_action :set_year, only: %i[show update destroy]

      # GET /answer_books
      def index
        if params[:segment_id].present? && params[:stage_id].present?
          @years = Year.where(segment_id: params[:segment_id], stage_id: params[:stage_id]).order(:name)
        else
          @years = Year.all
        end
        render json: @years

      end

      # GET /answer_books/1
      def show
        render json: @year
      end

      # POST /answer_books
      def create
        @year = Year.new(year_params)

        if @year.save
          render json: @year, status: :created
        else
          render json: @year.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /answer_books/1
      def update
        if @year.update(year_params)
          render json: @year
        else
          render json: @year.errors, status: :unprocessable_entity
        end
      end

      # DELETE /answer_books/1
      def destroy
        @year.destroy
      end

      private

      # Use callbacks to share common setup or constraints between actions.
      def set_year
        @year = Year.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def year_params
        params.require(:year).permit(:name, :segment_id, :stage_id)
      end
    end
  end
end
