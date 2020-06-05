module Api
  class SegmentsController < ApiController
    def index
      @segments = Segment.all

      render json: @segments
    end

    private

    def segment_params
      params.require(:segment).permit(:name, :color)
    end
  end
end
