module Api
  class ActivitySequencesController < ApiController
    before_action :authenticate_api_user!, except: %i[index show search]
    before_action :set_teacher, only: %i[show index create destroy update]
    before_action :set_collection, only: %i[index show create update destroy]
    before_action :set_collection_activity_sequence, only: %i[destroy update]
    before_action :set_activity_sequence, only: %i[show update]
    before_action :check_collection_owner, only: %i[create update]
    include Api::Concerns::ActivitySequenceSearchable

    def index
      render_unauthorized_resource && return if @collection && !user_signed_in?
      if @collection
        @activity_sequences = @collection.activity_sequences.published.includes(:collection_activity_sequences)
        @activity_sequences = paginate(@activity_sequences)
      else
        @activity_sequences = search_activity_sequences
      end

      render :index
    end

    def show
      render :show
    end

    def create
      @collection_activity_sequence = @collection.collection_activity_sequences
                                                 .build(collection_activity_sequences_params)
      if @collection_activity_sequence.save
        @activity_sequence = @collection_activity_sequence.activity_sequence # find because show json
        render :show, status: :created
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
      if @collection
        render_unauthorized_resource && return unless user_signed_in?
        @activity_sequence = @collection.activity_sequences.find_by(id: params[:id])
        raise ActiveRecord::RecordNotFound unless @activity_sequence
      else
        @activity_sequence = ActivitySequence.friendly.find(params[:slug])
      end
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

      render_no_content && return unless @collection_activity_sequence
    end

    def check_user_permission
      render_no_content && return unless @teacher
      render_unauthorized_resource && return \
        if current_user&.id != @teacher&.user_id
    end

    def check_collection_owner
      return unless @collection
      render_unauthorized_resource && return if @collection.teacher.user.id != current_user.id
    end
  end
end
