class UsersController < ApplicationController
  def show
    @user = User.find(params[:id]) # URLのパラメータからユーザーを取得
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
end
