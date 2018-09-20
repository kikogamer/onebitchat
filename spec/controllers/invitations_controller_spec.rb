require 'rails_helper'

RSpec.describe InvitationsController, type: :controller do
    include Devise::Test::ControllerHelpers

    before(:each) do
        @request.env["devise.mapping"] = Devise.mappings[:user]
        @current_user = FactoryBot.create(:user)
        sign_in @current_user
    end

    describe "GET #index" do
        it "Returns success" do
            get :index
            expect(response).to have_http_status(:success)
        end
    end

    describe "POST #create" do
        before(:each) do
            request.env["HTTP_ACCEPT"] = 'application/json'
        end

        context "User belongs the team" do
            before(:each) do
                @team = create(:team, user: @current_user)
                @invitation_attributes = attributes_for(:invitation, team_id: @team.id, email: @current_user.email)
                post :create, params: { invitation: @invitation_attributes }
            end

            it "Returns created" do
                expect(response).to have_http_status(:created)
            end

            it "Invitation was created with user and team" do
                expect(Invitation.last.user).to eql(@current_user)
                expect(Invitation.last.team).to eql(@team)
            end
        end  
        
        context "User already belongs the team" do
            before(:each) do
                @user = create(:user)
                @team = create(:team, user: @user)
                @team_user = create(:team_user, team: @team, user: @user)
                @invitation_attributes = attributes_for(:invitation, team_id: @team_user.team.id, email: @team_user.user.email)
                post :create, params: {invitation: @invitation_attributes}
            end

            it "Returns Unprocessable Entity" do               
                expect(response).to have_http_status(:unprocessable_entity)
            end
        end

        context "User not exists" do
            before(:each) do
                team = create(:team, user: @current_user)
                name = FFaker::Lorem.word
                email = FFaker::Internet.email
                invitation_attributes = attributes_for(:invitation, team_id: team.id, name: name, email: email)
                post :create, params: {invitation: invitation_attributes}
            end

            it "Returns created" do
                expect(response).to have_http_status(:created)
            end
        end
    end

    describe "DELETE #destroy" do
        before(:each) do
            request.env["HTTP_ACCEPT"] = 'application/json'
        end

        context "Invitation is from the user" do
            before(:each) do
                @team = create(:team, user: @current_user)
                @invitation = create(:invitation, team: @team, user: @team.user)
                delete :destroy, params: { id: @invitation.id }
            end

            it "Returns success" do               
                expect(response).to have_http_status(:success)
            end

            it "The invitation was deleted" do
                expect(Invitation.where(id: @invitation.id).present?).to be false
            end
        end

        context "Invitation isn't from the user" do
            it "Returns forbidden" do
                team = create(:team, user: @current_user)
                user = create(:user)
                invitation = create(:invitation, team: team, user: user)
                delete :destroy, params: { id: invitation.id }

                expect(response).to have_http_status(:forbidden)
            end   
            
            it "Returns not_found" do
                id = 1;
                delete :destroy, params: { id: id }                
                expect(response).to have_http_status(:not_found)
            end
        end
    end

    describe "PUT #update" do
        before(:each) do
            request.env["HTTP_ACCEPT"] = 'application/json'
        end

        it "Returns success" do
            team = create(:team, user: @current_user)
            invitation = create(:invitation, team: team, user: team.user)
            invitation_attributes = attributes_for(:invitation, team_id: team.id, email: team.user.email)
            put :update, params: { id: invitation.id, invitation: invitation_attributes }

            expect(response).to have_http_status(:success)
            expect(Invitation.last.joined_date.present?).to be true
        end

        it "Returns not_found" do
            id = 1;
            invitation_attributes = attributes_for(:invitation)
            put :update, params: { id: id, invitation: invitation_attributes }
                
            expect(response).to have_http_status(:not_found)
        end
    end
end