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
end
