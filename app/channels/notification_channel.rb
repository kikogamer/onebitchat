class NotificationChannel < ApplicationCable::Channel
  
  def subscribed
    stream_from "#{params[:team_id]}"
  end
end
