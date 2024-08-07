class PostsController < ApplicationController
  def index
    @posts = Post.includes(:user).order("created_at DESC")
    
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
  end

  private

  def post_params
    params.require(:post).permit(:title,:image,:content).merge(user_id: curremt_user.id)
  end
end
