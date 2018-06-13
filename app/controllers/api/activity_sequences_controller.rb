module Api
  class ActivitySequencesController < ApiController
    before_action :set_activity_sequence, only: %i[show]

    def index
      @activity_sequences = ActivitySequence.where_optional_params(params)
      raise ActiveRecord::RecordNotFound unless @activity_sequences.present?

      render :index
    end

    def show
      render :show
    end

    private

    def activity_sequence_params
      params.permit(
        :slug,
        :year,
        :curricular_component_friendly_id,
        :sustainable_development_goal_id,
        :knowledge_matrix_id,
        :learning_objective_id,
        :axis_id,
        :activity_type_id
      )
    end

    def set_activity_sequence
      @activity_sequence = ActivitySequence.friendly.find(params[:slug])
    end
  end
end
