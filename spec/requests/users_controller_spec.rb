require 'rails_helper'

RSpec.describe "UsersController", type: :request do
  let(:user) { create(:user) }

  describe "GET /users/new" do
    it "should display Sign Up form when user is not logged in" do
      get new_user_path

      expect(response).to have_http_status(200)
      expect(response.body).to include("Sign up")
      expect(response.body).to include("Create my account")
    end

    it "should display error message and redirect to root_path if user is already logged in" do
      login_as(user.email, user.password)
      get new_user_path

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

    it "should create a user when all necessary params are supplied" do
      post users_path, params: { user: { email: "user@example.com", password: "password123", password_confirmation: "password123", user_type: "organization" } }

      expect(response).to redirect_to login_path
      expect(response).to have_http_status(302)

      follow_redirect!

      expect(response.body).to include("Account created successfully! Please login below.")
    end

    it "should display the 'Sign Up' view if one or more necessary params are missing" do
      post users_path, params: { user: { email: "another_user@example.com", password: "password123", password_confirmation: "", user_type: "organization" } }

      expect(response.body).to include("Password confirmation doesn&#39;t match Password")
      expect(response.body).to include("The form contains 1 error.")
    end
  end

  describe "PATCH /users/:id" do
    it "should update the user's information" do
      login_as(user.email, user.password)
      user_email = user.email

      patch user_path(user.id), params: { user: { password: "password456", password_confirmation: "password456" } }

      expect(response).to redirect_to user_path(user.id)
      expect(response).to have_http_status(302)

      follow_redirect!

      expect(response.body).to include("Account updated successfully!")

      logout_user
      login_as(user.email, "password456")
      follow_redirect!

      expect(response.body).to include("<b>Your Email:</b> #{user_email}")
    end
  end
end
