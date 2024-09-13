class UsersController < ApplicationController
  before_action :authenticate_user!
  def show
    @user = User.find(params[:id]) # URLのパラメータからユーザーを取得
    @is_guest = guest_user?(@user) # ユーザーがゲストかどうかを判定
    @posts = @user.posts.order(created_at: :desc) # ユーザーの投稿を取得
    @from_nickname = params[:from] == 'nickname'
    
    # ユーザーが参加しているDMルームとグループルームを取得
    @dm_rooms = @user.rooms.where(is_group: false)
    @group_rooms = @user.rooms.where(is_group: true)

    # 各DMルームの最後のメッセージを取得
    @last_messages = {}
    @dm_rooms.each do |room|
      @last_messages[room.id] = room.messages.order(created_at: :desc).first
    end

    # ユーザーの通知を取得
    @notifications = Notification.where(user: @user).order(created_at: :desc)
  end

  def edit
    @user = current_user # URLのパラメータからユーザーを取得
  end

  def update
    @user = current_user
    if @user.update(user_params)
      redirect_to @user, notice: 'プロフィールが更新されました。'
    else
      render :edit
    end
  end


  private

  def guest_user?(user)
    # ユーザーがゲストかどうかを判定するロジック
    user.guest?
  end

  def user_params
    params.require(:user).permit(:nickname, :thought, :profile_image)
  end
 
end
