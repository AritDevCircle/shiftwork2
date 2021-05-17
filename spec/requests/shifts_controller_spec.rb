require 'rails_helper'

RSpec.describe "ShiftsControllers", type: :request do
  let(:sample_org) { create(:organization) }
  let(:sample_org_user) { create(:user) }
  let(:sample_worker_1) { create(:worker) }
  let(:sample_worker_2) { create(:worker) }
  let(:sample_shift_1) { create(:shift, :chef_role, :filled_shift, worker_id: sample_worker_1.id) }
  let(:shift_starting_soon) { create(:shift, :chef_role, :filled_shift, worker_id: sample_worker_2.id, shift_start: DateTime.now + 6.hours, shift_end: DateTime.now + 18.hours) }

  describe "GET /index action" do
    it "should redirect to organization show page if current_user.has_org?" do
      org_user = User.find_by(id: sample_org.user_id)
      login_as(org_user.email, "password123")
      get shifts_path

      expect(response).to have_http_status(302)

      follow_redirect!

      expect(response.body).to include("Your Shifts")
    end

    it "should show all shifts if current_user does not have_org?" do
      shift1 = create(:shift, :chef_role, :open_shift, organization_id: sample_org.id)
      login_as(sample_org_user.email, "password123")
      get shifts_path

      expect(response.body).to include("List of All Shifts")
      expect(response.body).to include("Chef")
    end
  end
  
  describe "GET /shifts/new action" do
    it "should successfully display Create Shift form if current_user has_org?" do
      org_user = User.find_by(id: sample_org.user_id)
      login_as(org_user.email, "password123")
      get new_shift_path

      expect(response).to have_http_status(200)
      expect(response.body).to include("Create Shift")
    end

    it "should display error and redirect to shifts page if current_user does not have_org?" do
      login_as(sample_org_user.email, "password123")
      get new_shift_path

      expect(response).to have_http_status(302)

      follow_redirect!

      expect(response.body).to include("You are unauthorized to create new shifts.")
      expect(response.body).to include("List of All Shifts")
    end
  end

  describe "POST /shifts action" do
    it "should create a shift when all necessary params are supplied" do  
      org_user = User.find_by(id: sample_org.user_id)   
      login_as(org_user.email, "password123")
      
      post shifts_path, params: { shift: { shift_role: "Bartender", shift_description: "Mix all the drinks", shift_start: "2021-12-30 12:00:00", shift_end: "2021-12-30 15:00:00", shift_pay: "22", shift_open: true } }
      
      expect(response).to have_http_status(302)

      follow_redirect!

      expect(response.body).to include("Shift created successfully!")
    end

    it "should display the 'Create Shift' form if one or more necessary params are missing" do
      org_user = User.find_by(id: sample_org.user_id)
      login_as(org_user.email, "password123")

      post shifts_path, params: { shift: { shift_role: "Bartender", shift_description: "", shift_start: "2021-12-30 12:00:00", shift_end: "2021-12-30 15:00:00", shift_pay: "22", shift_open: true } }

      expect(response).to have_http_status(302)

      follow_redirect!

      expect(response.body).to include("Shift description is too short (minimum is 10 characters)")
      expect(response.body).to include("Create Shift")
    end
  end

  describe "PATCH /shifts/update action" do
    it "should update the shift's information" do
      org_user = User.find_by(id: sample_org.user_id)
      login_as(org_user.email, "password123")

      sample_shift = create(:shift, :chef_role, organization_id: sample_org.id, shift_open: true)

      get organization_path(sample_org.id)

      expect(response.body).to include("Chef")
      expect(response.body).to include("Cook all the food")
      
      patch shift_path(sample_shift.id), params: { shift: { shift_role: "Bartender", shift_description: "Mix all the drinks", shift_start: "2021-12-30 12:00:00", shift_end: "2021-12-30 15:00:00", shift_pay: "22", shift_open: true } }
      
      expect(response).to have_http_status(302)

      follow_redirect!

      expect(response.body).to include("Shift updated successfully!")
    end

    it "should display the 'Update Shift' form if one or more necessary params are missing" do
      org_user = User.find_by(id: sample_org.user_id)
      login_as(org_user.email, "password123")
      
      test_shift = create(:shift, :chef_role, organization_id: sample_org.id, shift_open: true)

      get organization_path(sample_org.id)

      expect(response.body).to include("Chef")
      expect(response.body).to include("Cook all the food")

      patch shift_path(test_shift.id), params: { shift: { shift_role: "Bartender", shift_description: "", shift_start: "2021-12-30 12:00:00", shift_end: "2021-12-30 15:00:00", shift_pay: "22", shift_open: true } }

      expect(response).to have_http_status(422)

      expect(response.body).to include("Shift description is too short (minimum is 10 characters)")
      expect(response.body).to include("Update Shift")
    end
  end

  describe "DELETE /shifts action" do
    it "should delete the shift, display success message and redirect to shifts list" do
      org_user = User.find_by(id: sample_org.user_id)
      login_as(org_user.email, "password123")
      test_shift_1 = create(:shift, :chef_role, organization_id: sample_org.id, shift_open: true)
      test_shift_2 = create(:shift, :bartender_role, organization_id: sample_org.id, shift_open: true)

      delete shift_path(test_shift_1.id)
  
      expect(response).to have_http_status(302)

      follow_redirect!
  
      expect(response.body).to include("Delete")
      expect(response.body).to include("Shift deleted successfully!")
      expect(response.body).to include("Mix all the drinks")
      expect(response.body).not_to include("Cook all the food")
    end
  end 

  describe "PATCH /shifts/take action" do
    it "should display error message if shift is already taken by a worker" do
      worker_user = User.find_by(id: sample_worker_2.user_id)
      login_as(worker_user.email, "password123")
      
      patch take_shift_path(sample_shift_1.id)

      expect(response).to have_http_status(302)

      follow_redirect!

      expect(response.body).to include("This Shift is already taken!")
    end

    it "should redirect to worker_path and display success message if current_worker takes a shift" do
      sample_shift_2 = create(:shift, :bartender_role, :open_shift)
      sample_worker_3 = create(:worker)
      worker_user = User.find_by(id: sample_worker_3.user_id)
      login_as(worker_user.email, "password123")

      patch take_shift_path(sample_shift_2.id)

      expect(response).to have_http_status(302)

      follow_redirect!

      expect(response.body).to include("Shift has been assigned to you successfully!")

      sample_shift_2.reload

      expect(sample_shift_2.shift_open).to be(false)
      expect(sample_shift_2.worker_id).to eq(sample_worker_3.id)
    end
  end

  describe "PATCH /shifts/drop action" do
    it "should display error message and not allow worker drop shift if current_worker isn't assigned to shift" do
      sample_worker_3 = create(:worker)
      worker_user = User.find_by(id: sample_worker_3.user_id)
      login_as(worker_user.email, "password123")

      patch drop_shift_path(sample_shift_1.id)

      expect(response).to have_http_status(302)

      follow_redirect!
      
      expect(response.body).to include("Shift is NOT assigned to you; cannot drop.")
    end

    it "should display error message and not allow worker drop shift if it starts within 24 hours" do
      worker_user = User.find_by(id: sample_worker_2.user_id)
      login_as(worker_user.email, "password123")

      patch drop_shift_path(shift_starting_soon.id)

      expect(response).to have_http_status(302)

      follow_redirect!

      expect(response.body).to include("Shift starts in less than 24 hours; cannot drop.")
    end

    it "should redirect to worker_path and display success message if shift dropped successfully" do
      worker_user = User.find_by(id: sample_worker_1.user_id)
      login_as(worker_user.email, "password123")

      patch drop_shift_path(sample_shift_1.id)

      expect(response).to have_http_status(302)

      follow_redirect!

      expect(response.body).to include("Shift has been dropped successfully!")
    end
  end
end


 