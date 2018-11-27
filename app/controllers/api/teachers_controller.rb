module Api
  class TeachersController < ApiController
    before_action :authenticate_api_user!
    before_action :set_teacher, only: %i[show update me]
    before_action :check_user_permission, only: %i[show update]

    def me
      render :me
    end

    def show
      render :show
    end

    def create
      @teacher = Teacher.new(teacher_params)
      @teacher.user_id = current_user.id

      if @teacher.save
        render :show, status: :created
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
      teacher = current_user.teacher || current_user.create_teacher
      teacher.avatar.attach(teacher_params[:avatar])
      head :ok
    rescue StandardError
      head :unprocessable_entity
    end

    private

    def teacher_params
      params.require(:teacher).permit(:id, :nickname, :avatar)
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
