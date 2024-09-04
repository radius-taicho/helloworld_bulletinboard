class CommentsController < ApplicationController
  before_action :set_post
  before_action :set_comment, only: [:show, :edit, :update, :destroy]

  def create
    @comment = @post.comments.new(comment_params)
    @comment.user = current_user || User.guest

    if @comment.save
      render json: { comment: @comment, message: 'コメントが追加されました' }, status: :created
    else
      render json: { errors: @comment.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
    respond_to do |format|
      format.json do
        render json: { form: render_to_string(template: 'comments/edit-form', locals: { comment: @comment }, formats: [:html]) }
      end
    end
  rescue ActiveRecord::RecordNotFound => e
    logger.error "Comment not found: #{e.message}"
    render json: { error: 'Comment not found' }, status: :not_found
  rescue StandardError => e
    logger.error "Internal server error: #{e.message}"
    render json: { error: 'Internal server error' }, status: :internal_server_error
  end

  def edit
    respond_to do |format|
      form_html = render_to_string(partial: 'edit-form', locals: { comment: @comment }, formats: [:html])
      Rails.logger.debug("Generated form HTML: #{form_html}")
      format.json { render json: { form: form_html } }
    end
  end

  def update
    time_difference = Time.current - @comment.created_at
  
    if time_difference <= 600 && @comment.user.id == (current_user&.id || User.guest.id)
      if @comment.edit_count < 1
        if @comment.update(comment_params)
          @comment.update(edit_count: @comment.edit_count + 1) # 編集回数を増加
          respond_to do |format|
            format.html 
            format.json { render json: { comment: @comment }, status: :ok }
          end
        else
          respond_to do |format|
            format.html
            format.json { render json: { errors: @comment.errors.full_messages }, status: :unprocessable_entity }
          end
        end
      else
        respond_to do |format|
          format.html
          format.json { render json: { errors: ['このコメントは既に編集済みです'] }, status: :forbidden }
        end
      end
    else
      respond_to do |format|
        format.html 
        format.json { render json: { errors: ['このコメントの編集は期限が切れています。'] }, status: :forbidden }
      end
    end
  end
  
  
  

  def destroy
    time_difference = Time.current - @comment.created_at

    if time_difference <= 1800 && @comment.user.id == (current_user&.id || User.guest.id)
      if @comment.destroy
        flash[:notice] = "コメントが削除されました。"
        redirect_to post_path(@post), notice: 'コメントが削除されました'
      else
        flash[:alert] = "コメントの削除に失敗しました。再試行してください。"
        redirect_back(fallback_location: post_path(@post))
      end
    else
      flash[:alert] = "コメントは投稿したユーザーかつ30分以内にしか削除できません。"
      redirect_back(fallback_location: post_path(@post))
    end
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end

  def set_comment
    @comment = @post.comments.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:content).merge(user_id: current_user&.id || User.guest.id)
  end
end
