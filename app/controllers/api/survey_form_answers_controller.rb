module Api
  class SurveyFormAnswersController < ApiController

    # before_action :authenticate_api_user!
    before_action :set_survey_form, only: [:new]

    def create
      survey_form_answer = SurveyFormAnswer.find_or_initialize_by(id: params[:id])
      survey_form_answer.update(survey_form_answer_params)
      if survey_form_answer.save
        render json: survey_form_answer, status: :created
      else
        render json: survey_form_answer.errors, status: :unprocessable_entity
      end
    end

    def new
      @survey_form_answer = SurveyFormAnswer.find_by(
        teacher_id: params[:teacher_id],
        survey_form_id: params[:survey_form_id]
      )
      if !@survey_form_answer.present?
        answers = []
        @survey_form.survey_form_content_blocks.each do |content_block|
          answers << Answer.new({
            survey_form_content_block_id: content_block.id,
            teacher_id: params[:teacher_id],
            comment: nil,
            rating: nil,
            })
        end

        @survey_form_answer = SurveyFormAnswer.new({
          teacher_id: params[:teacher_id],
          survey_form_id: params[:survey_form_id],
          finished: nil,
          anonymous: nil,
          })
      else
        answers = Answer.where(survey_form_answer_id: @survey_form_answer.id)
      end
      @answers_attributes = answers
      render :new
    end

    private

    def survey_form_answer_params
      params.require(:survey_form_answer).permit(
        :teacher_id,
        :anonymous,
        :finished,
        :survey_form_id,
        answers_attributes: [
          :id,
          :rating,
          :comment,
          :teacher_id,
          :survey_form_content_block_id
          ]
        )
    end

    def set_survey_form
      @survey_form = SurveyForm.find_by(id: params[:survey_form_id])
    end
  end
end
