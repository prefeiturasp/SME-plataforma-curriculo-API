module Api
  class RoadmapsController < ApiController
    def index
      @roadmaps = Roadmap.order(:id).all

      render :index
    end
  end
end
