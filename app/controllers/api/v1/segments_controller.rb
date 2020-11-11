module Api
  module V1
    class SegmentsController < ApiController

      before_action :set_segment, only: %i[show update destroy]

      # GET /v1/segments
      def index
        @segments = Segment.all

        render json: @segments
      end

      # GET /v1/segments/1
      def show
        render json: @segment
      end

      # POST /v1/segments
      def create
        @segment = Segment.new(segment_params)

        if @segment.save
          render json: @segment, status: :created
        else
          render json: @segment.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /v1/segments/1
      def update
        if @segment.update(segment_params)
          render json: @segment
        else
          render json: @segment.errors, status: :unprocessable_entity
        end
      end

      # DELETE /v1/segments/1
      def destroy
        @segment.destroy
      end

      private

      # Use callbacks to share common setup or constraints between actions.
      def set_segment
        @segment = Segment.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def segment_params
        params.require(:segment).permit(:name, :color, :sequence)
      end
    end
  end
end
