class RoomChannel < ApplicationCable::Channel
  def subscribed
    stream_from "room_#{params[:room_id]}"
  end

  def unsubscribed
    # ユーザーの接続が切れたときに行うクリーンアップ処理
    
    # 例1: ルームからユーザーを離脱させる
    # ルームに参加中のユーザーリストから削除する
    room = Room.find(params[:room_id])
    user = current_user # 接続中のユーザー
    room.users.delete(user) if room.users.exists?(user.id)
    
    # 例2: ストリームの購読を解除する (通常は自動的に行われるので、特に明示的な解除は不要)
    stop_all_streams
    
    # 例3: ログ出力などで接続解除を記録
    Rails.logger.info "User #{user.nickname} unsubscribed from room #{room.id}"
    
    # 例4: 通知やイベント発火
    # ルームのユーザーに対して「ユーザーが退出した」旨の通知をリアルタイムに送信
    ActionCable.server.broadcast "room_#{room.id}", { message: "#{user.nickname} has left the room" }
  end
end
