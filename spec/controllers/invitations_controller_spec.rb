require 'rails_helper'

RSpec.describe InvitationsController, type: :controller do
    include Devise::Test::ControllerHelpers

    before(:each) do
        @request.env["devise.mapping"] = Devise.mappings[:user]
        @current_user = FactoryBot.create(:user)
        sign_in @current_user
    end

    describe "GET #show" do
        context "user exists" do
            it "Returns success" do
                get :show, params: {user_id: @current_user.id}

                expect(response).to have_http_status(:success)
            end
        end

        context "user not exists" do
            it "Returns Unprocessable Entity" do
                user = FactoryBot.create(:user)
                get :show, params: {user_id: user.id}

                expect(response).to have_http_status(:unprocessable_entity)
            end
        end
    end

    describe "POST #create" do
        context "User belongs the team" do
            before(:each) do
                @team = create(:team, user: @current_user)
                @invitation_attributes = attributes_for(:invitation, team: @team, user: team.user)
                post :create, params: {invitation: @invitation_attributes}
            end

            it "Returns created" do
                expect(response).to have_http_status(:created)
            end

            it "Invitation was created with user and team" do
                expect(Invitation.last.user).to eql(@current_user)
                expect(Invitation.last.team).to eql(@team)
            end
        end  
        
        context "User doesn't belongs the team" do
            before(:each) do
                user = FactoryBot.create(:user)
                team = create(:team)
                invitation_attributes = attributes_for(:invitation, team: team, user: user)
                post :create, params: {invitation: @invitation_attributes}
            end

            it "Returns Unprocessable Entity" do               
                expect(response).to have_http_status(:unprocessable_entity)
            end
        end
    end

    describe "DELETE #destroy" do
        before(:each) do
            request.env["HTTP_ACCEPT"] = 'application/json'
        end

        context "Invitation is from the user" do
            before(:each) do
                team = create(:team, user: @current_user)
                @invitation = create(:invitation, team: team, user: team.user)
                delete :destroy, params: { id: invitation.id }
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
                id = Invitation.last.id + 1;
                delete :destroy, params: { id: id }
                
                expect(response).to have_http_status(:not_found)
            end
        end
    end
end