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
        :years,
        :curricular_component_friendly_ids,
        :sustainable_development_goal_ids,
        :knowledge_matrix_ids,
        :learning_objective_ids,
        :axis_ids,
        :activity_type_ids
      )
    end

    def set_activity_sequence
      @activity_sequence = ActivitySequence.friendly.find(params[:slug])
    end
  end
end
