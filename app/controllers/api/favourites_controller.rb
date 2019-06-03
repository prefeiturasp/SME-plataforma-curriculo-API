module Api
  class FavouritesController < ApiController
    before_action :set_teacher, only: %i[index create destroy]
    before_action :check_user_permission, only: %i[create destroy]
    before_action :set_favourite, only: %i[destroy]

    def index
      @favourites = Favourite.challenges.where teacher_id: @teacher.id
    end

    def new
      @favourite = Favourite.new
    end

    def create
      @favourite = Favourite.new favourite_params

      if @favourite.save
        render json: {
          location: api_teacher_favourites_path(teacher_id: @teacher.id)
        }, status: :created
      else
        render json: @favourite.errors, status: :unprocessable_entity
      end
    end

    def destroy
      @favourite.destroy
    end

    private
      def favourite_params
        nparams = params.require(:favourite).permit :favouritable_id, :favouritable_type
        nparams[:teacher_id] = params[:id] || params[:teacher_id]

        if params[:challenge] || params[:favourite][:challenge]
          nparams[:favouritable_type] = 'Challenge'
          nparams[:favouritable_id]   = params[:challenge] || params[:favourite][:challenge]
        end

        nparams
      end

      def set_favourite
        @favourite = Favourite.challenges.where teacher_id: @teacher.id, id: params[:favourite_id]

        raise ActiveRecord::RecordNotFound if @favourite.blank?
      end

      def set_teacher
        @teacher = Teacher.find params[:id] || params[:teacher_id]
      end

      def check_user_permission
        render json: { error: 'Acesso negado' }, status: :unauthorized \
          if current_user&.id != @teacher&.user_id
      end
  end
end
