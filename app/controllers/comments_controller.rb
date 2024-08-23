class CommentsController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.new(comment_params)
    @comment.user = current_user || User.guest

    if @comment.save
      # コメントの追加が成功した場合
      render json: { comment: @comment, message: 'コメントが追加されました' }, status: :created
    else
      # コメントの追加が失敗した場合
      render json: { errors: @comment.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end
end
