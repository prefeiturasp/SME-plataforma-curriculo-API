module Api
  module V1
    class KnowledgeMatricesController < ApplicationController
      before_action :set_knowledge_matrix, only: %i[show update destroy]

      # GET /knowledge_matrices
      def index
        @knowledge_matrices = KnowledgeMatrix.all

        render json: @knowledge_matrices
      end

      # GET /knowledge_matrices/1
      def show
        render json: @knowledge_matrix
      end

      # POST /knowledge_matrices
      def create
        @knowledge_matrix = KnowledgeMatrix.new(knowledge_matrix_params)

        if @knowledge_matrix.save
          render json: @knowledge_matrix, status: :created
        else
          render json: @knowledge_matrix.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /knowledge_matrices/1
      def update
        if @knowledge_matrix.update(knowledge_matrix_params)
          render json: @knowledge_matrix
        else
          render json: @knowledge_matrix.errors, status: :unprocessable_entity
        end
      end

      # DELETE /knowledge_matrices/1
      def destroy
        @knowledge_matrix.destroy
      end

      private

      # Use callbacks to share common setup or constraints between actions.
      def set_knowledge_matrix
        @knowledge_matrix = KnowledgeMatrix.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def knowledge_matrix_params
        params.require(:knowledge_matrix).permit(:title, :know_description, :for_description, :sequence)
      end
    end
  end
end
