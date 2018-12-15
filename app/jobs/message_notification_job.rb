class MessageNotificationJob < ApplicationJob
    queue_as :default

    def perform(message)
        m = message.messagable        
        (m.class == Channel ? type = "channels" : type = "talks")
        notification_name = "#{m.team.id}"
        
        ActionCable.server.broadcast(notification_name, {
                                                            type: type,
                                                            id: m.id,
                                                            user_id: message.user.id
                                                        })                       
    end
end