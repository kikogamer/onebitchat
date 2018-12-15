class Message < ApplicationRecord
    belongs_to :messagable, polymorphic: true
    belongs_to :user
    has_many :message_user_reads, :dependent => :destroy
    validates_presence_of :body, :user
    
    def is_read(user)
        MessageUserRead.where(message: self, user: user).exists?
    end

    after_create_commit {MessageBroadcastJob.perform_later self}
    after_create_commit {MessageNotificationJob.perform_later self}
end
