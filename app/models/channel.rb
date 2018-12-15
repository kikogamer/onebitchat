class Channel < ApplicationRecord
  has_many :messages, as: :messagable, :dependent => :destroy
  belongs_to :team
  belongs_to :user
  validates_presence_of :slug, :team, :user
  validates :slug, format: { with: /\A[a-zA-Z0-9]+\Z/ }
  validates_uniqueness_of :slug, :scope => :team_id

  def has_unread_messages(user_id)
    message_ids = self.messages.pluck(:id)
    message_ids.length > MessageUserRead.where(message_id: message_ids, user_id: user_id).count
  end
end