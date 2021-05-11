require 'rails_helper'

RSpec.describe "ShiftsControllers", type: :request do
  
  describe "GET /shifts/new" do
    it "should successfully display Create Shift form if user is org" do
    get new_shift_path

    expect(response).to have_http_status(200)
    expect(response.body).to include("Create Shift")
  end

  it "should display success message and redirect to list of shifts" do
    get new_shift_path

    expect(response).to redirect_to organization_path(current_org_id)
    expect(response).to have_http_status(302)

    follow_redirect!

    expect(response.body).to include("Shift created successfully!")
  end
  end


  describe "GET /shifts/:id/edit" do
    it "should allow org edit its shift" do
    get edit_shift_path

    expect(response).to have_http_status(200)
    expect(response.body).to include("NOTE: If you are NOT changing the dates, you must enter the current dates to update your shift.")
    expect(response.body).to include("Edit Shift")
    expect(response.body).to include("Update Shift")
   end

   it "should display success message and redirect to shifts list" do
    get edit_shift_path

    expect(response).to redirect_to organization_path(current_org_id)
    expect(response).to have_http_status(200)

    follow_redirect!

    expect(response.body).to include("Shift updated successfully!")
  end
  end


  describe "GET /shifts/:id" do
    it "should successfully show org all of its shifts" do
    get shifts_path

    expect(response).to have_http_status(200)
    expect(response.body).to include("Your Shifts")
    expect(response.body).to include("Create Shift")
  end
  end



  describe "POST /shifts" do
     it "should create a shift when all necessary params are supplied" do
      post shifts_path, params: { shift: { shift_role: "Bartender", shift_description: "Mix all the drinks", shift_start: "2021-12-30 12:00:00", shift_end: "2021-12-30 15:00:00", shift_pay: "22", shift_status: "open", shift_status: "filled" } }
    end
      expect(response).to redirect_to organization_path(current_org_id)
      expect(response).to have_http_status(302)

      follow_redirect!

      expect(response.body).to include("Shift created successfully!")
    end

    it "should display the 'Create Shift' view if one or more necessary params are missing" do
      post shifts_path, params: { shift: { shift_role: "Bartender", shift_description: "Mix all the drinks", shift_start: "2021-12-30 12:00:00", shift_end: "2021-12-30 15:00:00", shift_pay: "22", shift_status: "open", shift_status: "filled" } }

      expect(response.body).to include("Shift description can't be blank, Shift description is too short(minimum is 10 characters)")
      expect(response.body).to include("Shift pay must be greater than or equal to 0")
      expect(response.body).to include("Shift duration must be at least 1 hour!")
      expect(response.body).to include("Shift cannot end before it starts")
    end
  end


  describe "PATCH /shifts/:id" do
    it "should update the shift's information" do
      patch shift_path(shifts.id), params: { shift: { shift_role: "Bartender", shift_description: "Mix all the drinks", shift_start: "2021-12-30 12:00:00", shift_end: "2021-12-30 15:00:00", shift_pay: "22", shift_status: "open", shift_status: "filled" } }

      expect(response).to redirect_to organization_path(current_org_id)
      expect(response).to have_http_status(302)

      follow_redirect!

      expect(response.body).to include("Shift updated successfully!")
  end
end


describe "DELETE /shifts/:id" do
  it "should delete a shift" do
    delete shift_path(shifts.id)

    expect(response).to have_http_status(200)
    expect(response.body).to include("Delete")
    expect(response.body).to include("Pop up alert confirm message")
   end

   it "should display alert message and redirect to shifts list" do
    delete shift_path(shifts.id)

    expect(response).to redirect_to organization_path(current_org_id)
    expect(response).to have_http_status(200)

    follow_redirect!

    expect(response.body).to include("Shift deleted successfully!")
  end
  end