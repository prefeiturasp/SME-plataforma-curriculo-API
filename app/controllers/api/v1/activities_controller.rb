module Api
  module V1
    class ActivitiesController < ApplicationController
      before_action :set_activity, only: %i[show update destroy]

      # GET /activities
      def index
        @activities = Activity.all

        render json: @activities
      end

      # GET /activities/1
      def show
        render json: @activity
      end

      # POST /activities
      def create
        @activity = Activity.new(activity_params)

        if @activity.save
          render json: @activity, status: :created
        else
          render json: @activity.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /activities/1
      def update
        if @activity.update(activity_params)
          render json: @activity
        else
          render json: @activity.errors, status: :unprocessable_entity
        end
      end

      # DELETE /activities/1
      def destroy
        @activity.destroy
      end

      private

      def set_activity
        @activity = Activity.find(params[:id])
      end

      def activity_params
        params.require(:activity).permit(
          :sequence,
          :title,
          :estimated_time,
          :content,
          :image,
          :activity_sequence_id,
          curricular_component_ids: []
        )
      end
    end
  end
end
