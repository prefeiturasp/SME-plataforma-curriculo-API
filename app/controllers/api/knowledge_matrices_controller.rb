module Api
  class KnowledgeMatricesController < ApiController
    def index
      @knowledge_matrices = KnowledgeMatrix.all.order(:sequence)

      render :index
    end
  end
end
