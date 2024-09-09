class DirectMessageRequestsController < ApplicationController
  def create
    sender_id = current_user.id
    receiver_id = direct_message_request_params[:receiver_id]

    existing_request = DirectMessageRequest.find_by(sender_id: sender_id, receiver_id: receiver_id)

    if existing_request
      render json: { success: false, errors: ['You have already sent a request.'] }, status: :unprocessable_entity
    else
      @request = DirectMessageRequest.new(direct_message_request_params.merge(sender_id: sender_id))

      if @request.save
        send_direct_message_request_email(@request)
        Notification.create(
          user: @request.receiver, # 受信者に通知
          message: "#{@request.sender.nickname}からメッセージリクエストがあります",
          notification_type: 'dm_request'
        )
        render json: { success: true }
      else
        Rails.logger.error("DirectMessageRequest creation failed: #{@request.errors.full_messages.join(', ')}")
        render json: { success: false, errors: @request.errors.full_messages }, status: :unprocessable_entity
      end
    end
  rescue StandardError => e
    Rails.logger.error("An error occurred during DirectMessageRequest creation: #{e.message}\n#{e.backtrace.join("\n")}")
    render json: { success: false, errors: ['An internal server error occurred.'] }, status: :internal_server_error
  end

  def approve
    @request = DirectMessageRequest.find(params[:id])

    if @request.update(status: 'approved')
      # メッセージルームを作成、その他の処理
      Notification.create(
        user: @request.sender,
        message: "#{@request.receiver.nickname}があなたのメッセージリクエストを承認しました",
        notification_type: 'dm_approved'
      )
      render json: { success: true, message: 'リクエストが承認されました' }
    else
      render json: { success: false, message: '承認に失敗しました' }, status: :unprocessable_entity
    end
  end

  def reject
    @request = DirectMessageRequest.find(params[:id])

    if @request.update(status: 'rejected')
      Notification.create(
        user: @request.sender,
        message: "#{@request.receiver.nickname}があなたのメッセージリクエストを拒否しました",
        notification_type: 'dm_rejected'
      )
      render json: { success: true, message: 'リクエストが拒否されました' }
    else
      render json: { success: false, message: '拒否に失敗しました' }, status: :unprocessable_entity
    end
  end


  private

  def direct_message_request_params
    params.require(:direct_message_request).permit(:receiver_id)
  end

  def send_direct_message_request_email(request)
    DirectMessageMailer.request_email(request).deliver_now
  end
end
