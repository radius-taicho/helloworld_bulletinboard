# app/models/notification.rb
class Notification < ApplicationRecord
  belongs_to :user

  # バリデーション（例: メッセージの必須化）
  validates :message, presence: true
end
