class MessagesController < ApplicationController
  def create
    @room = Room.find(params[:room_id])
    @message = @room.messages.new(message_params)
    
    # current_userをメッセージの送信者（sender）として設定
    @message.sender = current_user

    # 受信者をルーム内の他のユーザーとして設定
    @message.receiver = @room.receiver_user(current_user)

    if @message.save
      Rails.logger.debug "Message saved successfully: #{@message.inspect}"
      redirect_to @room, notice: 'メッセージが送信されました。'
    else
      Rails.logger.error "Message save failed: #{@message.errors.full_messages.join(', ')}"
      redirect_to @room, alert: 'メッセージの送信に失敗しました。'
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end
