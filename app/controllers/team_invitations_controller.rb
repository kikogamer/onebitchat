class TeamInvitationsController < ApplicationController
  before_action :set_team_invitation, only: [:update, :destroy]
  before_action :set_joined_date, only: [:update]
  
  def create
    @team_invitation = TeamInvitation.new(team_invitation_params)

    respond_to do |format|
      if TeamUser.where(user_id: @team_invitation.user_id, team_id: @team_invitation.team_id).exists?
        format.json { render json: 'user already belongs the team', status: :unprocessable_entity }
      elsif TeamInvitation.where(user_id: @team_invitation.user_id, team_id: @team_invitation.team_id, joined_date: nil).exists?
        format.json { render json: 'user already has pending invitation', status: :unprocessable_entity }
      elsif @team_invitation.save
        format.json { render json: @team_invitation, status: :created }
      else
        format.json { render json: @team_invitation.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize! :destroy, @team_invitation
    @team_invitation.destroy

    respond_to do |format|
      format.json { render json: true }
    end
  end

  def index
    @team_invitations = current_user.team_invitations
    respond_to do |format|
      format.html { render :index }
    end
  end

  def update
    TeamUser.transaction do
      @team_invitation.update(joined_date: Time.zone.today)
      team_user = TeamUser.new(team_id: @team_invitation.team.id, user_id: current_user.id)
      
      respond_to do |format|
        if team_user.save
          format.html { redirect_to "/#{@team_invitation.team.slug}" }
        else
          format.html { redirect_to main_app.root_url, notice: team_user.errors }
        end
      end
    end  
  end

  private

  def team_invitation_params
    name = params[:team_invitation][:name]
    email = params[:team_invitation][:email]
    
    #invite user if him doesn't exists
    user = User.find_by(email: email) 
    user = User.invite!(name: name, email: email) unless user.present?        
    
    params.require(:team_invitation).permit(:team_id).merge(user_id: user.id)
  end

  def set_team_invitation
    @team_invitation = TeamInvitation.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    respond_to do |format|
      format.json { render json: 'record not found', status: :not_found }
    end
  end

  def set_joined_date
    @team_invitation.joined_date = Time.zone.today
  end
end
