require 'rails_helper'

RSpec.describe "OrganizationsControllers", type: :request do
  let(:org_user) { create(:user) }
  let(:worker_user) { create(:user, :worker_user_type) }
  let(:test_org) { create(:organization, user_id: org_user.id)}
  let(:test_worker) { create(:worker, user_id: worker_user.id) }

  describe "GET /organizations/new" do

    it "should display Create Organization form when user is logged in as organization user_type but hasn't the org account yet" do
      Organization.destroy_all
      login_as(org_user.email, org_user.password)
      get new_organization_path

      expect(response).to have_http_status(200)
      expect(response.body).to include("<h1>Create Organization</h1>")
    end

    # Test commented out as it is not implemented yet so it will fail:

    # it "should display 'You do not have authority to access that.' warning when user is logged in as worker and tries to access the organizations/new page" do
    #   Worker.destroy_all
    #   login_as(worker_user.email, worker_user.password)
    #   get new_organization_path

    #   expect(response).to redirect_to user_path
    #   expect(response).to have_http_status(302)

    #   follow_redirect!

    #   expect(response.body).to include("You do not have authority to access that.")
    # end

    # Test commented out as it is not implemented yet so it will fail:
    
    # it "should display 'You have already created your organization.' warning when an organization user has already filled their data" do
    #   Organization.destroy_all
    #   login_as(org_user.email, org_user.password)
    #   get new_organization_path

    #   expect(response).to redirect_to user_path
    #   expect(response).to have_http_status(302)

    #   follow_redirect!

    #   expect(response.body).to include("You have already created your organization.")
    # end

  end

  describe "GET /organizations/:id/edit" do
    it "should display Edit Organization form when user is logged in as an organization" do
      Organization.destroy_all
      login_as(org_user.email, org_user.password)
      get edit_organization_path(test_org.id)

      expect(response).to have_http_status(200)
      expect(response.body).to include('value="123 Some Street"')
    end

    it "should redirect to user page and display \"You do not have authority to access that.\" alert when user is logged in as a worker" do
      login_as(worker_user.email, worker_user.password)
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
      get organization_path(test_org.id)

      expect(response).to have_http_status(200)

      expect(response.body).to include("Your Shifts")
      expect(response.body).to include("Create Shift")
    end

    it "should display basic Organization info when user is logged in as a worker" do
      login_as(worker_user.email, worker_user.password)
      get organization_path(test_org.id)

      expect(response).to have_http_status(200)

      expect(response.body).not_to include("Your Shifts")
      expect(response.body).not_to include("Create Shift")
    end
  end
  
  # create
  describe "POST /organizations" do
  
  end

  # update
  describe "PATCH /organizations/:id" do
  end

end
