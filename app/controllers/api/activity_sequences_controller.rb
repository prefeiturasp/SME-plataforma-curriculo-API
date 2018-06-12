module Api
  class ActivitySequencesController < ApiController
    def index
      @activity_sequences = ActivitySequence.where_optional_params(params)
      raise ActiveRecord::RecordNotFound unless @activity_sequences.present?

      render :index
    end

    private

    def activity_sequence_params
      params.permit(
        :year,
        :curricular_component_friendly_id,
        :sustainable_development_goal_id,
        :knowledge_matrix_id,
        :learning_objective_id,
        :axis_id,
        :activity_type_id
      )
    end
  end
end
