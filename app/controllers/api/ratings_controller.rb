module Api
  class RatingsController < ApiController
    def index
      @ratings = Rating.all.order(:sequence)

      render :index
    end
  end
end
