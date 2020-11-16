module Api
  class RegionalEducationBoardsController < ApiController
    def index
      @regional_education_boards = RegionalEducationBoard.all

      render :index
    end

    private

    def regional_education_board_params
      params.require(:regional_education_board).permit(:code, :name, :tag)
    end
  end
end
