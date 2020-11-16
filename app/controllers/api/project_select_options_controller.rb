module Api
  class ProjectSelectOptionsController < ApiController
    def index
      @options = {
        curricular_components: CurricularComponent.all,
        knowledge_matrices: KnowledgeMatrix.all,
        student_protagonisms: StudentProtagonism.all,
        segments: Segment.all,
        stages: Stage.all,
        years: Year.all,
        regional_education_boards: RegionalEducationBoard.all
      }

      render json: @options
    end
  end
end
