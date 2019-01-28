module Api
  class ActivitySequencePerformedsController < ApiController
    before_action :authenticate_api_user!
    before_action :set_teacher, only: %i[index show_ratings]
    before_action :check_user_permission, only: %i[index show_ratings]
    before_action :set_activity_sequence_performeds, only: %i[index]
    before_action :set_activity_sequence, only: %i[show_ratings]

    def index; end

    def show_ratings
      @activity_sequence_ratings = ActivitySequenceRating.includes(:activity_sequence)
                                                         .where(activity_sequences: {
                                                                  slug: @activity_sequence.slug
                                                                })
    end

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
                                              .all_or_with_evaluated(evaluated_filter)
    end

    def set_activity_sequence
      @activity_sequence = ActivitySequence.find_by(slug: params[:activity_sequence_slug])
    end

    def requested_teacher_id
      params['teacher_id']
    end

    def evaluated_filter
      %w[true false].include?(params['evaluated']) ? params['evaluated'] == 'true' : nil
    end

    def check_user_permission
      render_no_content && return unless @teacher
      render_unauthorized_resource && return \
        if current_user&.id != @teacher&.user_id
    end
  end
end
