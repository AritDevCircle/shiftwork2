require 'rails_helper'

RSpec.describe "OrganizationsController", type: :request do
  let(:org_user) { create(:user) }
  let(:worker_user) { create(:user, :worker_user_type) }

  before do
    Organization.destroy_all
    Worker.destroy_all
  end

  # show
  describe "GET /organizations/:id" do
    it "should display Org info when user is the current organization" do
      login_as(org_user.email, org_user.password)
      test_org = create(:organization, user_id: org_user.id)
      get organization_path(test_org.id)

      expect(response).to have_http_status(200)

      expect(response.body).to include("Your Shifts")
      expect(response.body).to include("Create Shift")
    end

    it "should display basic Org info when user is a worker" do
      login_as(worker_user.email, worker_user.password)
      test_org = create(:organization, user_id: org_user.id)
      get organization_path(test_org.id)

      expect(response).to have_http_status(200)

      expect(response.body).not_to include("Your Shifts")
      expect(response.body).not_to include("Create Shift")
    end
  end

  # new
  describe "GET /organizations/new" do
    it "should display new form when organization hasn't an account yet" do
      login_as(org_user.email, org_user.password)
      get new_organization_path

      expect(response).to have_http_status(200)
      expect(response.body).to include("<h1>Create Organization</h1>")
    end

    it "should display warning when a worker tries to access the new page" do
      login_as(worker_user.email, worker_user.password)
      get new_organization_path

      expect(response).to have_http_status(302)

      follow_redirect!

      expect(response.body).to include("You do not have authority to access that.")
    end

    it "should display warning when an org is already created" do
      login_as(org_user.email, org_user.password)
      test_org = create(:organization, user_id: org_user.id)
      get new_organization_path

      expect(response).to have_http_status(302)

      follow_redirect!

      expect(response.body).to include("You have already created your organization.")
    end
  end

  # create
  describe "POST /organizations" do
    before do
      login_as(org_user.email, org_user.password)
    end

    it "should create a new org when all necessary params are supplied" do
      post organizations_path, params: { organization: { org_name: "Test org name", org_description: "Test org description", org_address: "Test org address", org_city: "The City", org_state: "TO" } }

      expect(response).to have_http_status(302)

      follow_redirect!

      expect(response.body).to include("Organization created successfully!")
    end

    it "should display the 'Create org' view if one or more necessary params are missing" do
      post organizations_path, params: { organization: { org_name: "Test org name", org_description: "Test org description", org_address: "", org_city: "The City", org_state: "TO" } }

      expect(response.body).to include("Something went wrong.")
      expect(response.body).to include("<h1>Create Organization</h1>")
    end
  end

  # Edit: The target is to test the private verify_access method inside the org. controller 
  describe "GET /organizations/:id/edit" do
    it "should display Edit Org form when user is an organization" do
      login_as(org_user.email, org_user.password)
      test_org = create(:organization, user_id: org_user.id)
      get edit_organization_path(test_org.id)

      expect(response).to have_http_status(200)
      expect(response.body).to include('value="123 Some Street"')
    end

    it "should redirect and display alert when user is a worker" do
      login_as(worker_user.email, worker_user.password)
      test_org = create(:organization, user_id: org_user.id)
      get edit_organization_path(test_org.id)

      expect(response).to have_http_status(302)
  
      follow_redirect!

      expect(response.body).to include("You do not have authority to access that.")
    end
  end

  # update
  describe "PATCH /organizations/:id" do
    before do
      login_as(org_user.email, org_user.password)
    end

    it "should update the organization's information" do
      test_org = create(:organization, user_id: org_user.id)
      patch organization_path(test_org.id), params: { organization: { org_city:"Some other City" } }

      expect(response).to have_http_status(302)

      follow_redirect!

      expect(response.body).to include("Organization updated successfully!")
      expect(response.body).to include("Some other City")
    end
  end
end