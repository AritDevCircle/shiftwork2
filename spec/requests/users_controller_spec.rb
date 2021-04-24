require 'rails_helper'

RSpec.describe "UsersController", type: :request do
  let(:org_user) { create(:user, :org_user_type) }
  let(:sample_org) { create(:organization, user_id: org_user.id) }

  describe "GET /index" do
    before do
      Shift.destroy_all
      Organization.destroy_all
      User.destroy_all
    end

    it "returns page with list of open shifts only" do
      shift_1 = create(:shift, :bartender_role, :open_shift, organization_id: sample_org.id)
      shift_2 = create(:shift, :chef_role, :open_shift, organization_id: sample_org.id)
      shift_3 = create(:shift, :front_of_house_role, :filled_shift, organization_id: sample_org.id)
      
      get "/"
    
      expect(response).to have_http_status(200)
      expect(response.body).to include("Bartender")
      expect(response.body).to include("Chef")
      expect(response.body).not_to include("Front Of House")
    end
  end

  describe "POST /users" do
    before do
      User.destroy_all
    end

    it "creates a user when all necessary params are supplied" do
      post "/users", params: { user: { email: "org_user@example.com", password: "password123", password_confirmation: "password123", user_type: "organization" } }

      expect(response).to redirect_to login_path
      expect(response).to have_http_status(302)

      follow_redirect!

      expect(response.body).to include("Account created successfully! Please login below.")
    end

    it "displays the 'Sign Up' view when one or more necessary params are missing" do
      post "/users", params: { user: { email: "org_user@example.com", password: "password123", password_confirmation: "", user_type: "organization" } }

      expect(response.body).to include("Password confirmation doesn&#39;t match Password")
      expect(response.body).to include("The form contains 1 error.")
    end
  end
end
