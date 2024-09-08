class AddIndexToRoomUsers < ActiveRecord::Migration[7.1]
  def change
    add_index :room_users, [:user_id, :room_id], unique: true
  end
end

