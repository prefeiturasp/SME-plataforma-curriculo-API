module Api
  class ProfilesController < ApiController
    before_action :authenticate_api_user!

    def me
      render :me
    end
  end
end
