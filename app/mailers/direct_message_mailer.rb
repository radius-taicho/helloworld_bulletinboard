class DirectMessageMailer < ApplicationMailer
  default from: 'no-reply@yourapp.com'

  def request_email(direct_message_request)
    @direct_message_request = direct_message_request
    @sender = User.find(direct_message_request.sender_id)
    @receiver = User.find(direct_message_request.receiver_id)

    # メールの送信者アドレスを動的に設定する例
    mail(to: @receiver.email, from: 'custom-sender@yourapp.com', subject: 'New Direct Message Request')
  end
end
