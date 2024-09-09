# app/controllers/notifications_controller.rb
class NotificationsController < ApplicationController
  def mark_as_read
    notification = Notification.find(params[:id])
    notification.update(read: true)
    respond_to do |format|
      format.html { redirect_back(fallback_location: root_path) }
      format.js   # Railsが自動的に`mark_as_read.js.erb`を探して処理する
    end
  end

  # 承認の通知を作成
  def create_approval_notification
    notification = Notification.create(
      user_id: params[:user_id], # 通知を送るユーザーのID
      message: "あなたのDMリクエストが承認されました。",
      notification_type: 'approval'
    )
    render json: { message: '通知が送信されました', notification: notification }, status: :ok
  end

  # 拒否の通知を作成
  def create_rejection_notification
    notification = Notification.create(
      user_id: params[:user_id], # 通知を送るユーザーのID
      message: "あなたのDMリクエストが拒否されました。",
      notification_type: 'rejection'
    )
    render json: { message: '通知が送信されました', notification: notification }, status: :ok
  end
end
