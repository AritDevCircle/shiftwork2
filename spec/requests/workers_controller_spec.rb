require 'rails_helper'

RSpec.describe "WorkersController", type: :request do
  let(:sample_org_user) { create(:user) }
  let(:sample_worker_user) { create(:user, :worker_user_type) }
  # let(:sample_worker) { create(:worker, user_id: sample_worker_user.id) }
  # let(:sample_org) { create(:organization, user_id: sample_org_user.id) }
  
  describe "GET /workers/:id action" do
    it "should successfully display list of worker's shifts to the worker" do
      login_as(sample_worker_user.email, sample_worker_user.password)
      sample_worker = create(:worker, user_id: sample_worker_user.id)

      get worker_path(sample_worker.id)

      expect(response).to have_http_status(200)
      expect(response.body).to include("All Your Shifts")
    end
  end

  describe "GET /workers/new action" do
    it "should successfully display 'Create Worker' form if logged_in user is worker user_type but doesn't have worker account" do
      Worker.destroy_all
      login_as(sample_worker_user.email, sample_worker_user.password)
      get new_worker_path
      
      expect(response).to have_http_status(200)
      expect(response.body).to include("Create Worker Account")
    end
    
    it "should display warning when logged_in user has an existing worker account" do
      sample_worker = create(:worker, user_id: sample_worker_user.id)
      login_as(sample_worker_user.email, sample_worker_user.password)
      get new_worker_path

      expect(response).to have_http_status(302)

      follow_redirect!

      expect(response.body).to include("You are unauthorized to create a new worker.")
      expect(response.body).to_not include("Create Worker Account")
    end

    it "should display warning when logged_in user is an org" do
      login_as(sample_org_user.email, sample_org_user.password)
      get new_worker_path

      expect(response).to have_http_status(302)

      follow_redirect!

      expect(response.body).to include("You are unauthorized to create a new worker.")
      expect(response.body).to_not include("Create Worker Account")
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

      follow_redirect!

      expect(response.body).to include("Worker Account created successfully!")
      expect(response.body).to include("Sample City")
    end

    it "should display the 'Create Worker Account' form if one or more necessary params are missing" do
      post workers_path, params: { worker: { first_name: nil } }
      
      expect(response.body).to include("Something went wrong.")
      expect(response.body).to include("Create Worker Account")
    end
  end

  describe "GET /workers/:id/edit action" do
    before do
      @sample_worker = create(:worker, user_id: sample_worker_user.id)
    end
    # indirectly tests verify_access private method 
    it "should successfully display an 'Edit Worker' form to the worker" do
      login_as(sample_worker_user.email, sample_worker_user.password)
      get edit_worker_path(@sample_worker.id)

      expect(response).to have_http_status(200)
      expect(response.body).to include("Edit Workers Account")
    end

    it "should display warning if the user is not the worker" do
      login_as(sample_org_user.email, sample_org_user.password)
      get edit_worker_path(@sample_worker.id)

      expect(response).to have_http_status(302)

      follow_redirect!

      expect(response.body).to include("You do not have authority to access that.")
      expect(response.body).to_not include("Edit Workers Account")
    end
  end

  describe "PATCH /workers/:id" do
    it "should update the worker's information" do
      sample_worker = create(:worker, user_id: sample_worker_user.id)
      login_as(sample_worker_user.email, sample_worker_user.password)

      patch worker_path(sample_worker.id), params: { worker: { first_name:"Aegon" } }

      expect(response).to redirect_to user_path(sample_worker_user.id)
      expect(response).to have_http_status(302)

      follow_redirect!

      expect(response.body).to include("Worker Account updated successfully!")
      expect(response.body).to include("Aegon")
    end
  end
end
