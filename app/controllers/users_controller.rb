class UsersController < ApplicationController
  def show
    @user = User.find(params[:id]) # URLのパラメータからユーザーを取得
    @posts = @user.posts.order(created_at: :desc) # ユーザーの投稿を取得
  end
end
