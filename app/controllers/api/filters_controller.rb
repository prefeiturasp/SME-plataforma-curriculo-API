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

      render '/api/filters/activity_sequence_index'
    end

    def activity_sequence_index_filter
      if params[:curricular_component_friendly_id]
        curricular_component = CurricularComponent.friendly.find(params[:curricular_component_friendly_id])
        render status: :no_content unless curricular_component.present?
        @axes = curricular_component.axes.where(year: params[:year])
        @learning_objectives = curricular_component.learning_objectives.where(year: params[:year])
      else
        @axes = Axis.where(year: params[:year])
        @learning_objectives = LearningObjective.where(year: params[:year])
      end

      render '/api/filters/activity_sequece_index_filter'
    end

    private

    def set_activity_sequence_params
      params.permit(
        :year,
        :curricular_component_friendly_id
      )
    end
  end
end
