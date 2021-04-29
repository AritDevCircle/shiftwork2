require 'rails_helper'

RSpec.describe "UsersController", type: :request do
  let(:org_user) { create(:user, :org_user_type) }
  let(:sample_org) { create(:organization, user_id: org_user.id) }

  describe "GET /users/new" do
    it "displays Sign Up form when user is not logged in" do
      get "/users/new"

      expect(response).to have_http_status(200)
      expect(response.body).to include("Sign up")
      expect(response.body).to include("Create my account")
    end

    it "displays error message and root_path if user is logged in" do
      login_as(org_user)
      get "/users/new"

      expect(response).to redirect_to root_path
      expect(response).to have_http_status(302)

      follow_redirect!

      expect(response.body).to include("Already logged in. Sign out first to create a new account.")
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

  describe "PATCH /users/:id" do
    it "updates user information" do
      login_as(org_user)
      patch "/users/#{org_user.id}", params: { user: { password: "password456", password_confirmation: "password456" } }

      expect(response).to redirect_to user_path(org_user.id)
      expect(response).to have_http_status(302)

      follow_redirect!

      expect(response.body).to include("Account updated successfully!")
    end
  end
end
