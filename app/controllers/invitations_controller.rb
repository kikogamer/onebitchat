class InvitationsController < ApplicationController
  before_action :set_invitation, only: [:update, :destroy]
  before_action :set_joined_date, only: [:update]
  
  def create
    @invitation = Invitation.new(invitation_params)

    respond_to do |format|
      if TeamUser.where(user_id: @invitation.user_id, team_id: @invitation.team_id).exists?
        format.json { render json: 'user already belongs the team', status: :unprocessable_entity }
      elsif @invitation.save
        format.json { render json: @invitation, status: :created }
      else
        format.json { render json: @invitation.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize! :destroy, @invitation
    @invitation.destroy

    respond_to do |format|
      format.json { render json: true }
    end
  end

  def index
    @invitations = current_user.invitations
    respond_to do |format|
      format.html { render :index }
    end
  end

  def update
    respond_to do |format|
      if @invitation.update(invitation_params)
        format.json { render json: true }
      else
        format.json { render json: @invitation.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def invitation_params
    params.require(:invitation).permit(:team_id, :user_id)
  end

  def set_invitation
    @invitation = Invitation.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    respond_to do |format|
      format.json { render json: 'record not found', status: :not_found }
    end
  end

  def set_joined_date
    @invitation.joined_date = Time.zone.today
  end
end
