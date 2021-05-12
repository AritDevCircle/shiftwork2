require 'rails_helper'

RSpec.describe "WorkersControllers", type: :request do
  let(:user) { create(:user) }
  let(:worker) { create(:worker) }

  describe "GET /workers" do
    # workers #index    
    # should this response be a 204?
    # follow redirect
  end

  describe "POST /workers" do
    # workers #create
    before do
      Worker.destroy_all
    end
    # FIXME: getting a failure, redirect goes to login instead, why?
    it "should create a new worker when all necessary params are supplied" do
      post workers_path, params: { worker: { user_id: user.id, first_name: "Full", last_name: "Name", worker_city: "Cityville", worker_state:"AA", bio: ""} }

      expect(response).to redirect_to users_path
      expect(response).to have_http_status(302)

      follow_redirect!

      expect(response.body).to include("Worker Account created successfully!")
      expect(response.body).to include("Your Worker Account Details")
    end

    fit "should display an erorr message and re-render the form if necessary params are missing" do
      post workers_path, params: { worker: { user_id: user.id }}
      expect(response).to redirect_to users_path
      expect(response).to have_http_status(302)

      follow_redirect!

      expect(response.body).to include("Something went wrong.")
    end
    # users must be logged in to access
    # with errors
        # "Something went wrong."
    # with success
        # "Worker Account created successfully!"
        # follow redirect
        # check for new worker info
  end

  describe "GET /workers/new" do
    #  workers #new
    # as an org, TODO: orgs can access /workers/new page, check with group
    # as a worker, TODO: sees the form

  end

  describe "GET /workers/:id" do
    #   workers #show
    # as an org or other worker
        # Shows name and bio
    # as the worker
        # "All Your Shifts"
end

describe "GET /workers/:id/edit" do
    #   workers #edit
    # as an org
        # "You do not have authority to access that."
        # follow redirect to make sure it is the org's profile page
    # as another worker
    # as the worker
        # should show a form
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
