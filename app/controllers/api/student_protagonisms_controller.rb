module Api
  class StudentProtagonismsController < ApiController
    def index
      @student_protagonisms = StudentProtagonism.order(:sequence)

      render :index
    end

    private

    def student_protagonism_params
      params.require(:student_protagonism).permit(:title, :description, :sequence)
    end
  end
end
