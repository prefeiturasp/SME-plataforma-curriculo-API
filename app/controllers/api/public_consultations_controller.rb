module Api
  class PublicConsultationsController < ApiController
    before_action :authenticate_api_user!
    before_action :set_public_consultation, only: %i[show]

    def index
      @public_consultations = PublicConsultation.all

      render :index
    end

    def show
      render :show
    end

    private

    def public_consultation_params
      params.permit(:id)
    end

    def set_public_consultation
      @public_consultation = PublicConsultation.find(params[:id])
    end
  end
end
