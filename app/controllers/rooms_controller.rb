class RoomsController < ApplicationController
  def show
    @room = Room.find(params[:id])
    @messages = @room.messages.order(created_at: :asc)
    @message = Message.new
  end
end
