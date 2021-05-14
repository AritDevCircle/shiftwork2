require 'rails_helper'

RSpec.describe "ShiftsControllers", type: :request do
  let(:sample_org) { create(:organization) }
  let(:sample_user) { create(:user) }

  #describe "GET /index action" do
    #it "should redirect to organization show page if current_user.has_org?" do
      #org_user = User.find_by(id: sample_org.user_id)
      #login_as(org_user.email, "password123")
      #get shifts_path

      #expect(response).to have_http_status(302)

      #follow_redirect!

      #expect(response.body).to include("Your Shifts")
    #end

    #it "should show all shifts if current_user does not have org" do
      #shift1 = create(:shift, :chef_role, :open_shift, organization_id: sample_org.id)
      #login_as(sample_user.email, "password123")
      #get shifts_path

      #expect(response.body).to include("List of All Shifts")
      #expect(response.body).to include("Chef")
    #end
  #end
  
  #describe "GET /shifts/new action" do
    #it "should successfully display Create Shift form if current_user has org" do
      #org_user = User.find_by(id: sample_org.user_id)
      #login_as(org_user.email, "password123")
      #get new_shift_path

      #expect(response).to have_http_status(200)
      #expect(response.body).to include("Create Shift")
    #end

    #it "should display error and redirect to shifts page if current_user does not have org" do
      #login_as(sample_user.email, "password123")
      #get new_shift_path

      #expect(response).to have_http_status(302)

      #follow_redirect!

      #expect(response.body).to include("You are unauthorized to create new shifts.")
      #expect(response.body).to include("List of All Shifts")
    #end
  #end

  #describe "POST /shifts action" do
    #it "should create a shift when all necessary params are supplied" do  
      #org_user = User.find_by(id: sample_org.user_id)   
      #login_as(org_user.email, "password123")
      
      #post shifts_path, params: { shift: { shift_role: "Bartender", shift_description: "Mix all the drinks", shift_start: "2021-12-30 12:00:00", shift_end: "2021-12-30 15:00:00", shift_pay: "22", shift_open: true } }
      
      #expect(response).to have_http_status(302)

      #follow_redirect!

      #expect(response.body).to include("Shift created successfully!")
    #end

    #it "should display the 'Create Shift' form if one or more necessary params are missing" do
      #org_user = User.find_by(id: sample_org.user_id)
      #login_as(org_user.email, "password123")

      #post shifts_path, params: { shift: { shift_role: "Bartender", shift_description: "", shift_start: "2021-12-30 12:00:00", shift_end: "2021-12-30 15:00:00", shift_pay: "22", shift_open: true } }

      #expect(response).to have_http_status(302)

      #follow_redirect!

      #expect(response.body).to include("Shift description is too short (minimum is 10 characters)")
      #expect(response.body).to include("Create Shift")
    #end
  #end

  #describe "PATCH /shifts action" do
    #it "should update the shift's information" do
      #org_user = User.find_by(id: sample_org.user_id)
      #login_as(org_user.email, "password123")
      
      #patch shifts_path, params: { shift: { shift_role: "Bartender", shift_description: "Mix all the drinks", shift_start: "2021-12-30 12:00:00", shift_end: "2021-12-30 15:00:00", shift_pay: "22", shift_open: true } }
      
      #expect(response).to have_http_status(302)

      #follow_redirect!

      #expect(response.body).to include("Shift updated successfully!")
    #end

    it "should display the 'Update Shift' form if one or more necessary params are missing" do
      org_user = User.find_by(id: sample_org.user_id)
      login_as(org_user.email, "password123")

      patch shifts_path, params: { shift: { shift_role: "Bartender", shift_description: "", shift_start: "2021-12-30 12:00:00", shift_end: "2021-12-30 15:00:00", shift_pay: "22", shift_open: true } }

      expect(response).to have_http_status(302)

      follow_redirect!

      expect(response.body).to include("Shift description is too short (minimum is 10 characters)")
      expect(response.body).to include("Update Shift")
    end
  end

  describe "DELETE /shifts action" do
    it "should delete a shift" do
      org_user = User.find_by(id: sample_org.user_id)   
      login_as(org_user.email, "password123")

      delete shifts_path
  
      expect(response).to have_http_status(302)
      expect(response.body).to include("Delete")

      follow_redirect!
  
      expect(response.body).to include("Shift deleted successfully!")
    end
  
    it "should display alert message and redirect to shifts list" do
      org_user = User.find_by(id: sample_org.user_id)   
      login_as(org_user.email, "password123")

      delete shifts_path
  
      expect(response).to have_http_status(302)

      follow_redirect!
      
      expect(response.body).to include("Delete")
    end
  end 
end


 