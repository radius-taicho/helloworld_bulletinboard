class PostsController < ApplicationController
  def index
    @posts = Post.all.order(created_at: :desc)
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user = current_user || User.guest
  
    respond_to do |format|
      if @post.save
        format.json { render json: @post.as_json(include: { user: { only: :nickname } }, methods: [:image_url]), status: :created }
      else
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
    @post = Post.find(params[:id])
  end

  def destroy
    @post = Post.find(params[:id])
  
    # 投稿の作成時間と現在の時間の差を計算
    time_difference = Time.current - @post.created_at
  
    # 30分(1800秒)以内かどうかをチェック

    if time_difference <= 1800 && @post.user.id == (current_user&.id || User.guest.id)
      if @post.destroy
        flash[:notice] = "投稿が削除されました。"
        redirect_to root_path
      else
        flash[:alert] = "投稿の削除に失敗しました。再試行してください。"
        redirect_back(fallback_location: post_path(@post.id))
      end
    else
      flash[:alert] = "投稿は投稿したユーザーかつ30分以内にしか削除できません。"
      redirect_back(fallback_location: post_path(@post.id))
    end
    
  end
  


  private

  def post_params
    params.require(:post).permit(:title, :content, :image)
  end
end