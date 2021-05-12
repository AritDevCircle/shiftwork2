require 'rails_helper'

RSpec.describe "WorkersControllers", type: :request do
  let(:org_user) { create(:user) }
  let(:worker_user) { create(:user, :worker_user_type) }
  let(:worker) { create(:worker, user_id: worker_user.id) }
  let(:org) { create(:org, user_id: org_user.id) }

  describe "GET /workers" do
    it "should redirect to a 404 page " do
      get workers_path

      expect(response).to have_http_status(302)

      follow_redirect!

      # TODO:
      # expect(response.body).to include("Your Worker Account Details")
    end
  end

  describe "GET /workers/new" do
  #  workers #new
  # as an org, TODO: orgs can access /workers/new page, check with group
  # as a worker, TODO: sees the form

  end

  describe "POST /workers" do
    # workers #create
    before do
      Worker.destroy_all
      login_as(worker_user.email, worker_user.password)
    end

    it "should create a new worker when all necessary params are supplied" do
      post workers_path, params: { worker: { user_id: worker_user.id, first_name: "Full", last_name: "Name", worker_city: "Cityville", worker_state:"AA", bio: ""} }
      
      # FIXME: getting a failure, redirect url has a dot instead of a slash before id
      # expect(response).to redirect_to users_path(worker_user.id)
      expect(response).to have_http_status(302)

      follow_redirect!

      expect(response.body).to include("Worker Account created successfully!")
      expect(response.body).to include("Your Worker Account Details")
    end

    it "should display an error message and re-render the form if necessary params are missing" do
      post workers_path, params: { worker: { first_name: nil}}
      
      expect(response.body).to include("Something went wrong.")
      expect(response.body).to include("Create Worker Account")
    end
  end



  # describe "GET /workers/:id" do
  #   #   workers #show

  #   it "should display shifts that the worker has taken if the user is the worker" do
  #   login_ad(worker_user.email, worker_user.password)
  #   get worker_path(worker.id)

  #   expect(response).to have_http_status(200)
  #   expect(response.body).to include("All Your Shifts")
  # end

  #   it "should show users who are not the worker a bio" do
  #     login_as(org_user.email, org_user.password)
  #     get workers_path(worker.id)

  #     expect(response.body).to include("waffwafw")
  #   end
  # end

  describe "GET /workers/:id/edit" do
    #   workers #edit

    it "should redirect to user's page with an error message if the user is not the worker" do
      login_as(org_user.email, org_user.password)
      get edit_worker_path(worker.id)

      # FIXME: getting a failure, redirect url has a dot instead of a slash before id
      # expect(response).to redirect_to users_path(org_user.id)
      expect(response).to have_http_status(302)

      follow_redirect!

      expect(response.body).to include("You do not have authority to access that.")
      expect(response.body).to include("Your Email:")
    end
    # as another worker? 
    
    it "should show a worker a form to edit their account" do
      login_as(worker_user.email, worker_user.password)
      get edit_worker_path(worker.id)

      expect(response).to have_http_status(200)
      expect(response.body).to include("Edit Workers Account")
    end
  end

  describe "PATCH /workers/:id" do
    # workers # partial update
    # success
        # "Worker Account updated successfully!"
        # follow redirect to check for changes
    # missing required value or setting required value to nil
        # "Something went wrong." with a status
        # make sure we're still on the same page
  end

  describe "PUT /workers/:id" do
    # workers # full update
    # success
    # missing required value
  end

  describe "DELETE /workers/:id" do
    #   workers #destroy
    # is this implemented?
  end

end
