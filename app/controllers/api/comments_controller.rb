module Api
  class CommentsController < ApiController
    before_action :set_comment, only: %i[destroy]

    def index
      @comments = Comment.all
      render :index
    end

    def create
      comment = Comment.create(comment_params)
      if comment.save
        render json: comment, status: :created
      else
        render json: comment.errors, status: :unprocessable_entity
      end
    end

    def destroy
      @comment.destroy
    end

    private

    def comment_params
      params.require(:comment).permit(:teacher_id, :project_id, :body)
    end

    def set_comment
      @comment = Comment.find_by(id: params[:id])
    end
  end
end
