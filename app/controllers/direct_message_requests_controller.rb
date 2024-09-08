class DirectMessageRequestsController < ApplicationController
  def create
    sender_id = current_user.id
    receiver_id = direct_message_request_params[:receiver_id]

    existing_request = DirectMessageRequest.where(sender_id: sender_id, receiver_id: receiver_id).first

    if existing_request
      render json: { success: false, errors: ['You have already sent a request.'] }, status: :unprocessable_entity
    else
      @request = DirectMessageRequest.new(direct_message_request_params.merge(sender_id: sender_id))

      if @request.save
        send_direct_message_request_email(@request)
        render json: { success: true }
      else
        Rails.logger.error("DirectMessageRequest creation failed: #{@request.errors.full_messages.join(', ')}")
        render json: { success: false, errors: @request.errors.full_messages }, status: :unprocessable_entity
      end
    end
  rescue StandardError => e
    Rails.logger.error("An error occurred: #{e.message}")
    render json: { success: false, errors: ['An internal server error occurred.'] }, status: :internal_server_error
  end

  def approve
    # 承認処理のロジックを追加する
    # 例えば、リクエストを承認して、リダイレクトするなど
  end

  private

  def direct_message_request_params
    params.require(:direct_message_request).permit(:receiver_id)
  end

  def send_direct_message_request_email(request)
    DirectMessageMailer.request_email(request).deliver_now
  end
end
