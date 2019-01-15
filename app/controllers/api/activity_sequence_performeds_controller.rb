module Api
  class ActivitySequencePerformedsController < ApiController
    before_action :authenticate_api_user!
    before_action :set_teacher, only: %i[index]
    before_action :check_user_permission, only: %i[index]
    before_action :set_activity_sequence_performeds, only: %i[index]

    def index; end

    private

    def set_teacher
      @teacher = if requested_teacher_id.present?
                   Teacher.find_by(id: requested_teacher_id)
                 else
                   current_teacher
                 end
    end

    def set_activity_sequence_performeds
      @activity_sequence_performeds = @teacher.activity_sequence_performeds
                                              .ordered_by_created_at
    end

    def requested_teacher_id
      params['teacher_id']
    end

    def check_user_permission
      render_no_content && return unless @teacher
      render_unauthorized_resource && return \
        if current_user&.id != @teacher&.user_id
    end
  end
end
