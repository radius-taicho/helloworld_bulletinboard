class AddDirectMessageRequestIdToNotifications < ActiveRecord::Migration[7.1]
  def change
    add_reference :notifications, :direct_message_request, foreign_key: true, index: true
  end
end

