module Api
  module V1
    class ActivityTypesController < ApiController
      before_action :set_activity_type, only: %i[show update destroy]

      # GET /activity_types
      def index
        @activity_types = ActivityType.all

        render json: @activity_types
      end

      # GET /activity_types/1
      def show
        render json: @activity_type
      end

      # POST /activity_types
      def create
        @activity_type = ActivityType.new(activity_type_params)

        if @activity_type.save
          render json: @activity_type, status: :created
        else
          render json: @activity_type.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /activity_types/1
      def update
        if @activity_type.update(activity_type_params)
          render json: @activity_type
        else
          render json: @activity_type.errors, status: :unprocessable_entity
        end
      end

      # DELETE /activity_types/1
      def destroy
        @activity_type.destroy
      end

      private

      # Use callbacks to share common setup or constraints between actions.
      def set_activity_type
        @activity_type = ActivityType.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def activity_type_params
        params.require(:activity_type).permit(:name)
      end
    end
  end
end
