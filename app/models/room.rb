# app/models/room.rb
class Room < ApplicationRecord
  has_many :messages
  has_many :room_users
  has_many :users, through: :room_users

  def receiver_user(current_user)
    # ルーム内の他のユーザーを取得
    users.where.not(id: current_user.id).first
  end

end
