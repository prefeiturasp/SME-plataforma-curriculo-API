module Api
  class CollectionsController < ApiController
    before_action :authenticate_api_user!
    before_action :set_teacher, only: %i[index create show update destroy]
    before_action :set_collection, only: %i[show update destroy]

    def index
      @collections = paginate(@teacher.collections)

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
      @teacher = Teacher.find_by(id: params[:teacher_id])
      check_user_permission
    end

    def set_collection
      @collection = @teacher.collections.find(params[:id])
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
