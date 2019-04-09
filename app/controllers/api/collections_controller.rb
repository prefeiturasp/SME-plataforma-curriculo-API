module Api
  class CollectionsController < ApiController
    before_action :authenticate_api_user!
    before_action :set_activity_sequence, only: %i[index]
    before_action :set_teacher, only: %i[index create show update destroy]
    before_action :set_collection, only: %i[show update destroy]

    def index
      @collections = if @activity_sequence
                       paginate(@activity_sequence.collections.where(teacher_id: @teacher.id))
                     else
                       paginate(@teacher.collections)
                     end

      render :index
    end

    def create
      @collection = @teacher.collections.build(collection_params)

      if @collection.save
        render :show, status: :created
      else
        render json: @collection.errors, status: :unprocessable_entity
      end
    end

    def show
      render :show
    end

    def update
      if @collection.update(collection_params)
        render :show
      else
        render json: @collection.errors, status: :unprocessable_entity
      end
    end

    def destroy
      @collection.destroy
    end

    private

    def set_teacher
      @teacher = if params[:teacher_id].present?
                   Teacher.find_by(id: params[:teacher_id])
                 else
                   current_teacher
                 end
      check_user_permission
    end

    def set_collection
      @collection = @teacher.collections.find(params[:id])
    end

    def set_activity_sequence
      @activity_sequence = ActivitySequence.find_by(slug: params[:activity_sequence_slug])
    end

    def check_user_permission
      render_no_content && return unless @teacher
      render_unauthorized_resource && return \
        if current_user&.id != @teacher&.user_id
    end

    def collection_params
      params.require(:collection).permit(:id, :name, :teacher_id)
    end
  end
end
