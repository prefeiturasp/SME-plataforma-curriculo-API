module Api
  class RoadmapsController < ApiController
    def index
      @roadmaps = Roadmap.all
      raise ActiveRecord::RecordNotFound unless @roadmaps.present?

      render :index
    end
  end
end
