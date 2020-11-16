module Api
  class SchoolsController < ApiController
    def index
      @schools = School.all.order(:name)
      if (params[:regional_education_board_id].present?)
        @schools = School.where(
          regional_education_board_id: params[:regional_education_board_id]
        ).order(:name)
      end

      render json: @schools
    end

    private

    def school_params
      params.require(:school).permit(:name, :code, :regional_education_board_id, :school_type)
    end
  end
end
