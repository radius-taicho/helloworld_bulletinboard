class DirectMessageRequestsController < ApplicationController
  def create
    sender_id = current_user.id
    receiver_id = direct_message_request_params[:receiver_id]

    # 既存のリクエストを確認
    existing_request = DirectMessageRequest.find_by(sender_id: sender_id, receiver_id: receiver_id)

    if existing_request
      render json: { success: false, errors: ['You have already sent a request.'] }, status: :unprocessable_entity
      return
    end

    # 新しいリクエストを作成
    @direct_message_request = DirectMessageRequest.new(direct_message_request_params.merge(sender_id: sender_id))

    if @direct_message_request.save
      send_direct_message_request_email(@direct_message_request)
      render json: { success: true }, status: :created
    else
      Rails.logger.error("DirectMessageRequest creation failed: #{@direct_message_request.errors.full_messages.join(', ')}")
      render json: { success: false, errors: @direct_message_request.errors.full_messages }, status: :unprocessable_entity
    end
  rescue StandardError => e
    Rails.logger.error("An error occurred: #{e.message}")
    render json: { success: false, errors: ['An internal server error occurred.'] }, status: :internal_server_error
  end

  private

  def direct_message_request_params
    params.require(:direct_message_request).permit(:receiver_id)
  end

  def send_direct_message_request_email(direct_message_request)
    DirectMessageMailer.request_email(direct_message_request).deliver_now
  end
end
