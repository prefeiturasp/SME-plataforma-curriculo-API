module Api
  module V1
    class FileUploadsController < ApplicationController
      def create
        activity = Activity.find(params[:activity_id])
        if activity.content_images.attach(params[:activity][:content_images])
          render json: url_for(activity.content_images.last).to_json, status: :created
        else
          render json: @activity.errors, status: :unprocessable_entity
        end
      end
    end
  end
end
