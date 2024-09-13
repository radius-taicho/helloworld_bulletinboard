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
          user: @request.receiver,
          message: "#{@request.sender.nickname}からメッセージリクエストがあります",
          notification_type: 'dm_request',
          direct_message_request: @request
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
    @direct_message_request = DirectMessageRequest.find(params[:id])

    # 新しいDMルームの作成（名前は送信者と受信者の名前を使って生成）
    dm_room = Room.create!(name: "DM Room between #{@direct_message_request.sender.nickname} and #{@direct_message_request.receiver.nickname}", is_group: false)

    # RoomUserの作成（送信者と受信者をルームに追加）
    RoomUser.create!(user: @direct_message_request.sender, room: dm_room)
    RoomUser.create!(user: @direct_message_request.receiver, room: dm_room)

    # リクエストを承認したことを通知
    @direct_message_request.update(status: 'approved')

    # 承認したことを送信者に通知
    Notification.create(
      user: @direct_message_request.sender,
      message: "#{@direct_message_request.receiver.nickname}があなたのメッセージリクエストを承認しました",
      notification_type: 'dm_approved',
      direct_message_request: @direct_message_request
    )

    render json: { success: true, message: 'リクエストが承認され、DMルームが作成されました' }
  rescue ActiveRecord::RecordNotFound => e
    Rails.logger.error("DirectMessageRequest not found: #{e.message}")
    render json: { success: false, message: 'リクエストが見つかりませんでした' }, status: :not_found
  rescue StandardError => e
    Rails.logger.error("An error occurred during approval: #{e.message}\n#{e.backtrace.join("\n")}")
    render json: { success: false, message: '承認処理中にエラーが発生しました' }, status: :internal_server_error
  end

  def reject
    @request = DirectMessageRequest.find(params[:id])

    if @request.update(status: 'rejected')
      Notification.create(
        user: @request.sender,
        message: "#{@request.receiver.nickname}があなたのメッセージリクエストを拒否しました",
        notification_type: 'dm_rejected',
        direct_message_request: @request # ここで関連付けを追加
      )
      render json: { success: true, message: 'リクエストが拒否されました' }
    else
      render json: { success: false, message: '拒否に失敗しました' }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound => e
    Rails.logger.error("DirectMessageRequest not found: #{e.message}")
    render json: { success: false, message: 'リクエストが見つかりませんでした' }, status: :not_found
  rescue StandardError => e
    Rails.logger.error("An error occurred during rejection: #{e.message}\n#{e.backtrace.join("\n")}")
    render json: { success: false, message: '拒否処理中にエラーが発生しました' }, status: :internal_server_error
  end

  private

  def direct_message_request_params
    params.require(:direct_message_request).permit(:receiver_id)
  end

  def send_direct_message_request_email(request)
    DirectMessageMailer.request_email(request).deliver_now
  end
end
