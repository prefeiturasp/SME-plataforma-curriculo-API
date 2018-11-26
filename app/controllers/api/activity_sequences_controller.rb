module Api
  class ActivitySequencesController < ApiController
    before_action :set_activity_sequence, only: %i[show]
    before_action :set_collection, only: %i[index create update destroy]
    before_action :set_collection_activity_sequence, only: %i[destroy update]

    def index
      @activity_sequences = @collection ? @collection.activity_sequences.published : \
        ActivitySequence.where(status: :published)
                        .where_optional_params(params)

      @activity_sequences = paginate(@activity_sequences)

      render :index
    end

    def show
      render :show
    end

    def create
      return unless @collection
      @collection_activity_sequence = @collection.collection_activity_sequences.build(collection_activity_sequences_params)
      if @collection_activity_sequence.save
        render json: @collection_activity_sequence, status: :created
      else
        render json: @collection_activity_sequence.errors, status: :unprocessable_entity
      end
    end

    def destroy
      @collection_activity_sequence.destroy
    end

    def update
      if @collection_activity_sequence.update(collection_activity_sequences_params)
        render :show
      else
        render json: @collection_activity_sequence.errors, status: :unprocessable_entity
      end
    end

    private

    def activity_sequence_params
      params.permit(
        :slug,
        :years,
        :curricular_component_slugs,
        :sustainable_development_goal_ids,
        :knowledge_matrix_ids,
        :learning_objective_ids,
        :axis_ids,
        :activity_type_ids
      )
    end

    def collection_activity_sequences_params
      params.require(:collection_activity_sequence).permit(:activity_sequence_id, :sequence)
    end

    def set_activity_sequence
      identifier = params[:slug] || params[:id]
      # if params[:teacher_id] && params[:collection_id] && params[:id]
      #   identifier = params[:id]
      # else
      #   identifier = params[:slug]
      # end
      @activity_sequence = ActivitySequence.friendly.find(identifier)
    end

    def set_teacher
      return if params[:teacher_id].blank?
      @teacher = Teacher.find_by(id: params[:teacher_id])
      check_user_permission
    end

    def set_collection
      return if params[:teacher_id].blank? && params[:collection_id].blank?
      @collection = Collection.find(params[:collection_id])
    end

    def set_collection_activity_sequence
      return unless @collection
      @collection_activity_sequence = @collection.collection_activity_sequences
                                                  .find_by(activity_sequence_id: params[:id])
    end

    def check_user_permission
      render_no_content && return unless @teacher
      render_unauthorized_resource && return \
        if current_user&.id != @teacher&.user_id
    end
  end
end
