module Api
  class SurveyFormsController < ApiController

    def show
      @survey_form = SurveyForm.find_by(id: params[:id])
      @survey_form_content_blocks = SurveyFormContentBlock.where(survey_form_id: params[:id])

      render :show
    end
  end
end
