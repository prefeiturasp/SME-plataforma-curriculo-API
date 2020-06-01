module Api
  module V1
    class YearsController < ApiController

      before_action :set_year, only: %i[show update destroy]

      # GET /v1/years
      def index
        if params[:stage_id].present?
          @years = Year.where(stage_id: params[:stage_id]).order(:name)
        else
          @years = Year.all
        end

        render json: @years
      end

      # GET /v1/years/1
      def show
        render json: @year
      end

      # POST /v1/years
      def create
        @year = Year.new(year_params)

        if @year.save
          render json: @year, status: :created
        else
          render json: @year.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /v1/years/1
      def update
        if @year.update(year_params)
          render json: @year
        else
          render json: @year.errors, status: :unprocessable_entity
        end
      end

      # DELETE /v1/years/1
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
