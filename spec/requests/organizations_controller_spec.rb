require 'rails_helper'

RSpec.describe "OrganizationsControllers", type: :request do
  let(:org_user) { create(:user) }
  let(:worker_user) { create(:user, :worker_user_type) }

  describe "GET /organizations/new" do
    it "should display Create Organization form when user is logged in as organization user_type but hasn't the org account yet" do
      Organization.destroy_all
      login_as(org_user.email, org_user.password)
      get new_organization_path

      expect(response).to have_http_status(200)
      expect(response.body).to include("<h1>Create Organization</h1>")
    end

    # Not merged into main yet so it will fail:
    it "should display 'You do not have authority to access that.' warning when user is logged in as worker and tries to access the organizations/new page" do
      Worker.destroy_all
      login_as(worker_user.email, worker_user.password)
      get new_organization_path

      expect(response).to redirect_to user_path(worker_user.id)
      expect(response).to have_http_status(302)

      follow_redirect!

      expect(response.body).to include("You do not have authority to access that.")
    end

    # Not merged into main yet so it will fail:
    it "should display 'You have already created your organization.' warning when an organization user has already filled their data" do
      Organization.destroy_all
      login_as(org_user.email, org_user.password)
      test_org = create(:organization, user_id: org_user.id)
      get new_organization_path

      expect(response).to redirect_to user_path(org_user.id)
      expect(response).to have_http_status(302)

      follow_redirect!

      expect(response.body).to include("You have already created your organization.")
    end
  end

  describe "GET /organizations/:id/edit" do
    it "should display Edit Organization form when user is logged in as an organization" do
      Organization.destroy_all
      login_as(org_user.email, org_user.password)
      test_org = create(:organization, user_id: org_user.id)
      get edit_organization_path(test_org.id)

      expect(response).to have_http_status(200)
      expect(response.body).to include('value="123 Some Street"')
    end

    it "should redirect to user page and display \"You do not have authority to access that.\" alert when user is logged in as a worker" do
      Organization.destroy_all
      login_as(worker_user.email, worker_user.password)
      test_org = create(:organization, user_id: org_user.id)
      get edit_organization_path(test_org.id)

      expect(response).to redirect_to user_path(worker_user.id)
      expect(response).to have_http_status(302)
  
      follow_redirect!

      expect(response.body).to include("You do not have authority to access that.")
    end
  end

  # show
  describe "GET /organizations/:id" do
    it "should display Organization info when user is logged in as the current organization" do
      Organization.destroy_all
      login_as(org_user.email, org_user.password)
      test_org = create(:organization, user_id: org_user.id)
      get organization_path(test_org.id)

      expect(response).to have_http_status(200)

      expect(response.body).to include("Your Shifts")
      expect(response.body).to include("Create Shift")
    end

    it "should display basic Organization info when user is logged in as a worker" do
      Organization.destroy_all
      login_as(worker_user.email, worker_user.password)
      test_org = create(:organization, user_id: org_user.id)
      get organization_path(test_org.id)

      expect(response).to have_http_status(200)

      expect(response.body).not_to include("Your Shifts")
      expect(response.body).not_to include("Create Shift")
    end
  end

  # create
  describe "POST /organizations" do
    before do
      Organization.destroy_all
      login_as(org_user.email, org_user.password)
    end

    it "should create a new organization when all necessary params are supplied" do
      post organizations_path, params: { organization: { org_name: "Test org name", org_description: "Test org description", org_address: "Test org address", org_city: "The City", org_state: "TO" } }

      expect(response).to redirect_to user_path(org_user.id)
      expect(response).to have_http_status(302)

      follow_redirect!

      expect(response.body).to include("Organization created successfully!")
    end

    it "should display the 'Create organization' view if one or more necessary params are missing" do
      post organizations_path, params: { organization: { org_name: "Test org name", org_description: "Test org description", org_address: "", org_city: "The City", org_state: "TO" } }

      expect(response.body).to include("Something went wrong.")
      expect(response.body).to include("<h1>Create Organization</h1>")
    end
  end

  # update
  describe "PATCH /organizations/:id" do
    before do
      Organization.destroy_all
      login_as(org_user.email, org_user.password)
    end

    it "should update the organization's information" do
      test_org = create(:organization, user_id: org_user.id)
      patch organization_path(test_org.id), params: { organization: { org_city:"Some other City" } }

      expect(response).to redirect_to user_path(org_user.id)
      expect(response).to have_http_status(302)

      follow_redirect!

      expect(response.body).to include("Organization updated successfully!")
      expect(response.body).to include("Some other City")
    end
  end
end
