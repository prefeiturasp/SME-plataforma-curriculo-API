module Api
  class TeachersController < ApiController
    before_action :authenticate_user!
    before_action :set_teacher, only: %i[show update]
    before_action :check_user_permission, only: %i[show update]

    def show
      render :show
    end

    def create
      @teacher = Teacher.new(teacher_params)
      @teacher.user_id = current_user.id

      if @teacher.save
        render json: @teacher, status: :created
      else
        render json: @teacher.errors, status: :unprocessable_entity
      end
    end

    def update
      if @teacher.update(teacher_params)
        render :show
      else
        render json: @teacher.errors, status: :unprocessable_entity
      end
    end

    def avatar
      if current_user.teacher
        current_user.teacher.avatar.attach(avatar_params)
      else
        teacher = current_user.create_teacher
        teacher.avatar.attach(avatar_params)
      end
      head :ok
    end

    private

    def teacher_params
      params.permit(:id, :nickname, :avatar)
    end

    def avatar_params
      params.require(:avatar)
    end

    def set_teacher
      @teacher = Teacher.find(params[:id])
    end

    def check_user_permission
      render json: { error: 'Acesso negado' }, status: :unauthorized \
        if current_user&.id != @teacher&.user_id
    end
  end
end
