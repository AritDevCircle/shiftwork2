require 'rails_helper'

RSpec.describe "WorkersControllers", type: :request do
  let(:sample_org_user) { create(:user) }
  let(:sample_worker_user) { create(:user, :worker_user_type) }
  let(:sample_worker) { create(:worker, user_id: sample_worker_user.id) }
  let(:sample_org) { create(:organization, user_id: sample_org_user.id) }

  describe "GET /workers/new action" do

    it "should successfully display Create Worker Account form when user has a worker type and does not have a worker account" do
      Worker.destroy_all
      login_as(sample_worker_user.email, sample_worker_user.password)
      get new_worker_path
      
      expect(response).to have_http_status(200)

      expect(response.body).to include("Create Worker Account")
    end
    
    it "should display error message and redirect to user page if user is a worker with an existing worker account" do
      login_as(sample_worker_user.email, sample_worker_user.password)
      get new_worker_path

      expect(response).to have_http_status(302)

      follow_redirect!

      expect(response.body).to include("You are unauthorized to create new worker.")
      expect(response.body).to include("Your Email:")
    end

    it "should display error message and redirect to user page if user is an org" do
      login_as(sample_org_user.email, sample_org_user.password)
      get new_worker_path

      expect(response).to have_http_status(302)

      follow_redirect!

      expect(response.body).to include("You are unauthorized to create new worker.")
      expect(response.body).to include("Your Email:")
    end
  end

  describe "POST /workers action" do
    before do
      Worker.destroy_all
      login_as(sample_worker_user.email, sample_worker_user.password)
    end

    it "should create a new worker when all necessary params are supplied" do
      post workers_path, params: { worker: { user_id: sample_worker_user.id, first_name: "Full", last_name: "Name", worker_city: "Sample City", worker_state:"AA", bio: "Sample Bio"} }
      
      expect(response).to have_http_status(302)
      expect(response).to redirect_to user_path(sample_worker_user.id)

      follow_redirect!

      expect(response.body).to include("Worker Account created successfully!")
      expect(response.body).to include("Your Worker Account Details")
    end

    it "should display the 'Create Shift' form if one or more necessary params are missing" do
      post workers_path, params: { worker: { first_name: nil } }
      
      expect(response.body).to include("Something went wrong.")
      expect(response.body).to include("Create Worker Account")
    end
  end

  describe "GET /workers/:id action" do
    it "should display shifts that the worker has taken if worker views their page" do
      login_as(sample_worker_user.email, sample_worker_user.password)
      get worker_path(sample_worker.id)

      expect(response).to have_http_status(200)
      expect(response.body).to include("All Your Shifts")
    end
  end

  describe "GET /workers/:id/edit action" do
    it "should successfully display an 'Edit Worker' form to the worker" do
      login_as(sample_worker_user.email, sample_worker_user.password)
      get edit_worker_path(sample_worker.id)

      expect(response).to have_http_status(200)
      expect(response.body).to include("Edit Workers Account")
    end

    it "should display error and redirect to users page if the user is not the worker" do
      login_as(sample_org_user.email, sample_org_user.password)
      get edit_worker_path(sample_worker.id)

      expect(response).to redirect_to user_path(sample_org_user.id)
      expect(response).to have_http_status(302)

      follow_redirect!

      expect(response.body).to include("You do not have authority to access that.")
      expect(response.body).to include("Your Email:")
    end
    


    # should I test trying to edit a worker as another worker? 
  end

  describe "PATCH /workers/:id" do
    it "should update the worker's information" do
      login_as(sample_worker_user.email, sample_worker_user.password)

      patch worker_path(sample_worker.id), params: { worker: { first_name:"Aegon" } }

      expect(response).to redirect_to user_path(sample_worker_user.id)
      expect(response).to have_http_status(302)

      follow_redirect!

      expect(response.body).to include("Worker Account updated successfully!")
      expect(response.body).to include("Aegon")
    end
  end

  describe "PUT /workers/:id" do
    it "should update the sample_worker's information" do
      login_as(sample_worker_user.email, sample_worker_user.password)

      put worker_path(sample_worker.id), params: { worker: { user_id: sample_worker_user.id, first_name: "Updated", last_name: "Name", worker_city: "Cityville", worker_state:"AA", bio: ""} }

      expect(response).to redirect_to user_path(sample_worker_user.id)
      expect(response).to have_http_status(302)

      follow_redirect!

      expect(response.body).to include("Worker Account updated successfully!")
      expect(response.body).to include("Updated")
    end
  end
end
