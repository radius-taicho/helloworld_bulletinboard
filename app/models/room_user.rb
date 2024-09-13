# app/models/room_user.rb
class RoomUser < ApplicationRecord
  belongs_to :room
  belongs_to :user
end

