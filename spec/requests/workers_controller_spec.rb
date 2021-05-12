require 'rails_helper'

RSpec.describe "WorkersControllers", type: :request do
  describe "GET /workers" do
    # workers #index    
    # should this response be a 204?
    # follow redirect
  end

  describe "POST /workers" do
    # workers #create
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
