module Api
  class YearsController < ApiController
    def index
      @years = Year.order(:sequence)

      render :index
    end

    private

    def year_params
      params.require(:year).permit(:name, :segment_id, :stage_id)
    end
  end
end
