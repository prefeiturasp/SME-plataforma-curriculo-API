module Api
  class KnowledgeMatricesController < ApiController
    def index
      @knowledge_matrices = KnowledgeMatrix.all.order(:sequence)
      raise ActiveRecord::RecordNotFound unless @knowledge_matrices.present?

      render :index
    end
  end
end
