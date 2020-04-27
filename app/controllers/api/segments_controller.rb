module Api
  class SegmentsController < ApiController
    def index
      @segments = Segment.all

      render :index
    end

    private

    def segment_params
      params.require(:segment).permit(:name)
    end
  end
end
