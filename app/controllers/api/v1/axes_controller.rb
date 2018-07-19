module Api
  module V1
    class AxesController < ApiController
      before_action :set_axis, only: %i[show update destroy]

      # GET /axes
      def index
        @axes = Axis.all

        render json: @axes
      end

      # GET /axes/1
      def show
        render json: @axis
      end

      # POST /axes
      def create
        @axis = Axis.new(axis_params)

        if @axis.save
          render json: @axis, status: :created
        else
          render json: @axis.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /axes/1
      def update
        if @axis.update(axis_params)
          render json: @axis
        else
          render json: @axis.errors, status: :unprocessable_entity
        end
      end

      # DELETE /axes/1
      def destroy
        @axis.destroy
      end

      private

      # Use callbacks to share common setup or constraints between actions.
      def set_axis
        @axis = Axis.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def axis_params
        params.require(:axis).permit(
          :description,
          :curricular_component_id
        )
      end
    end
  end
end
