class MessagesController < ApplicationController
  before_action :authenticate_user!

  def create
    @room = Room.find(params[:room_id])
    @message = current_user.messages.build(message_params)
    @message.room = @room
    @message.sender = current_user
    @message.receiver = @room.receiver_user(current_user)

    if @message.save
      ActionCable.server.broadcast "room_#{@room.id}", {
        message: {
          content: @message.content,
          sender_id: @message.sender.id,
          sender_nickname: @message.sender.nickname
        },
        current_user_id: current_user.id  # 現在のユーザーIDを送信
      }

      respond_to do |format|
        format.html { redirect_to @room }
        format.json { render json: @message }
      end
    else
      respond_to do |format|
        format.html { redirect_to @room, alert: 'メッセージの送信に失敗しました。' }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end

  # メッセージをHTMLとしてレンダリングするメソッドは削除しました
end
