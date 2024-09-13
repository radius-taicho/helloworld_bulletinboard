class DirectMessageRequest < ApplicationRecord
  belongs_to :sender, class_name: 'User'
  belongs_to :receiver, class_name: 'User'
  has_many :notifications, dependent: :destroy

  # enumでステータスを管理
  enum status: { pending: 0, approved: 1, rejected: 2 }

  # バリデーション: 同じ sender と receiver の間で重複申請がないことを保証
  validates :sender_id, uniqueness: { scope: :receiver_id, message: "You already sent a request" }
end
