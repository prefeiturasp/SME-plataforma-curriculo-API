module Api
  class SegmentsController < ApiController
    def index
      @segments = Segment.order(:sequence)

      render json: @segments
    end

    private

    def segment_params
      params.require(:segment).permit(:name, :color)
    end
  end
end
