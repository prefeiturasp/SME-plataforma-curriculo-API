module Api
  module V1
    class CurricularComponentsController < ApiController
      before_action :set_curricular_component, only: %i[show update destroy]

      # GET /curricular_components
      def index
        @curricular_components = CurricularComponent.all

        render json: @curricular_components
      end

      # GET /curricular_components/1
      def show
        render json: @curricular_component
      end

      # POST /curricular_components
      def create
        @curricular_component = CurricularComponent.new(curricular_component_params)

        if @curricular_component.save
          render json: @curricular_component, status: :created
        else
          render json: @curricular_component.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /curricular_components/1
      def update
        if @curricular_component.update(curricular_component_params)
          render json: @curricular_component
        else
          render json: @curricular_component.errors, status: :unprocessable_entity
        end
      end

      # DELETE /curricular_components/1
      def destroy
        @curricular_component.destroy
      end

      private

      def set_curricular_component
        @curricular_component = CurricularComponent.friendly.find(params[:id])
      end

      def curricular_component_params
        params.require(:curricular_component).permit(:name, :color)
      end
    end
  end
end
