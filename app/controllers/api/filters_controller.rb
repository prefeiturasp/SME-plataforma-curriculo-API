module Api
  class FiltersController < ApiController
    before_action :set_activity_sequence_params, only: %i[activity_sequece_index_filter]

    def activity_sequence_index
      @years = LearningObjective.years
      @curricular_components = CurricularComponent.all
      @sustainable_development_goals = SustainableDevelopmentGoal.select(:id, :sequence, :name)
      @learning_objectives = LearningObjective.all
      @knowledge_matrices = KnowledgeMatrix.all
      @axes = Axis.all
      @activity_types = ActivityType.all
    end

    def activity_sequece_index_filter
      if params[:curricular_component_friendly_id]
        @axes = Axis.where(year: params[:year], curricular_component_id: params[:curricular_component_friendly_id])
        @learning_objectives = LearningObjective.where(year: params[:year], curricular_component_id: params[:curricular_component_friendly_id])
      else
        @axes = Axis.where(year: params[:year])
        @learning_objectives = LearningObjective.where(year: params[:year])
      end
    end

    private

    def set_activity_sequence_params
      params.permit(
        :year,
        :curricular_component_id
      )
    end
  end
end
