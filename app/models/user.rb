class User < ApplicationRecord
  has_many :teams
  has_many :messages
  has_many :talks, dependent: :destroy
  has_many :team_users, dependent: :destroy
  has_many :member_teams, through: :team_users, :source => :team
  has_many :team_invitations
  devise  :invitable, :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable
  mount_uploader :avatar, AvatarUploader

  def my_teams
    self.teams + self.member_teams
  end

  def my_team_invitations
    TeamInvitation.where(user: self, joined_date: nil)
  end

  def has_unread_messages(current_user_id, team_id)
    talk = Talk.find_by(user_one_id: [self.id, current_user_id], user_two_id: [self.id, current_user_id], team: team_id)
    if (talk)
      message_ids = talk.messages.where(user_id: self.id).pluck(:id)
      message_ids.length > MessageUserRead.where(message_id: message_ids, user_id: current_user_id).count
    else
      false  
    end
  end
end