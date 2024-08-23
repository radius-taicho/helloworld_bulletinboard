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


  def destroy
    @post = Post.find(params[:post_id])
    @comment = @post.comments.find(params[:id]) # コメントの特定

    time_difference = Time.current - @comment.created_at
  
    # 30分(1800秒)以内かどうかをチェック
    if time_difference <= 1800 && @comment.user.id == (current_user&.id || User.guest.id)
      if @comment.destroy
        flash[:notice] = "投稿が削除されました。"
        redirect_to post_path(@post), notice: 'コメントが削除されました'
      else
        flash[:alert] = "投稿の削除に失敗しました。再試行してください。"
        redirect_back(fallback_location: post_path(@post))
      end
    else
      flash[:alert] = "投稿は投稿したユーザーかつ30分以内にしか削除できません。"
      redirect_back(fallback_location:  post_path(@post))
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content).merge(user_id: current_user&.id || User.guest.id)
  end
  
end
