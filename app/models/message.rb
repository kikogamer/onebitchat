class Message < ApplicationRecord
    belongs_to :messagable, polymorphic: true
    belongs_to :user
    validates_presence_of :body, :user
    has_many :message_user_reads

    after_create_commit {MessageBroadcastJob.perform_later self}
    after_create_commit {MessageNotificationJob.perform_later self}
end
