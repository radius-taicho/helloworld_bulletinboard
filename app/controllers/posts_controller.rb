class PostsController < ApplicationController
  def index
    @posts = Post.all.order(created_at: :desc)
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user = current_user.nil? ? User.guest : current_user

    if @post.save
      respond_to do |format|
        format.json { render json: @post.as_json(only: [:id, :title, :content, :created_at]), status: :created }
      end
    else
      respond_to do |format|
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def post_params
    params.require(:post).permit(:title, :content)
  end
end