module Api
  class ActivitySequenceRatingsController < ApiController
    before_action :authenticate_api_user!
    before_action :set_activity_sequence, only: %i[create update index]
    before_action :set_teacher, only: %i[create update index]
    before_action :set_activity_sequence_performed, only: %i[create update]
    before_action :set_activity_sequence_rating, only: [:update]

    def index
      @activity_sequence_ratings = ActivitySequenceRating.includes(:activity_sequence)
                                                         .where(activity_sequences: {
                                                                  slug: @activity_sequence.slug
                                                                })
    end

    def create
      if (@activity_sequence_rating = ActivitySequenceRating.create_one_or_multiples(rating_params)).valid?
        render :show, status: :created
      else
        render json: @activity_sequence_rating.errors, status: :unprocessable_entity
      end
    rescue MissingRating => e
      render_unprocessable_entity(e.message)
    end

    def update
      if @activity_sequence_rating.update(activity_seq_rating_params)
        render :show, status: :ok, location: @activity_sequence_rating
      else
        render json: @activity_sequence_rating.errors, status: :unprocessable_entity
      end
    end

    private

    def set_teacher
      @teacher = Teacher.find_by(id: teacher_id)
      check_user_permission
    end

    def set_activity_sequence
      @activity_sequence = ActivitySequence.find(params[:activity_sequence_slug])
      render_no_content && return unless @activity_sequence
    end

    def set_activity_sequence_performed
      @activity_sequence_performed = ActivitySequencePerformed.find_by(
        teacher_id: @teacher.id,
        activity_sequence_id: @activity_sequence.id
      )
      error_message = I18n.t('activerecord.errors.messages.not_found_activity_sequence_performed')
      render_unprocessable_entity(error_message) && return unless @activity_sequence_performed
    end

    def set_activity_sequence_rating
      @activity_sequence_rating = ActivitySequenceRating.find(params[:id])
    end

    def check_user_permission
      render_no_content && return unless @teacher
      render_unauthorized_resource && return \
        if current_teacher != @teacher
    end

    def rating_params
      activity_seq_rating_params[:ratings].blank? ? simple_rating_params : block_rating_params
    end

    def block_rating_params
      activity_seq_rating_params[:ratings].each do |r|
        r[:activity_sequence_performed_id] = @activity_sequence_performed.id
      end
    end

    def simple_rating_params
      {
        activity_sequence_performed_id: @activity_sequence_performed.id,
        rating_id: activity_seq_rating_params[:rating_id],
        score: activity_seq_rating_params[:score]
      }
    end

    def activity_seq_rating_params
      params.require(:activity_sequence_rating).permit(
        :activity_sequence_id,
        :teacher_id,
        :rating_id,
        :score,
        ratings: %i[
          rating_id
          score
        ]
      )
    end

    def teacher_id
      params[:teacher_id].present? ? params[:teacher_id] : activity_seq_rating_params[:teacher_id]
    end
  end
end
