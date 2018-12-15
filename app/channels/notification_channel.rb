class NotificationChannel < ApplicationCable::Channel
  delegate  :ability, to: :connection
  protected :ability

  def subscribed
    stream_from "#{params[:team_id]}"
  end

  def receive(data)
    data["unread_messages"].each do |message|
      @message_user_read = MessageUserRead.new(message_id: message["message_id"], user_id: message["user_id"]) 
      @message_user_read.save
    end
  end
end
