module Api
  class StagesController < ApiController
    def index
      @stages = Stage.order(:sequence)

      render :index
    end

    private

    def stage_params
      params.require(:stage).permit(:name, :segment_id)
    end
  end
end
