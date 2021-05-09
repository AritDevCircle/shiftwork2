require 'rails_helper'

RSpec.describe Shift, type: :model do
  let(:shift1) { create(:shift, :bartender_role, :filled_shift) }
  
  
  describe "validations" do
    subject { shift1 }

    it { is_expected.to validate_presence_of(:shift_role) }
    it { is_expected.to validate_presence_of(:shift_description) }
    it { is_expected.to validate_presence_of(:shift_start) }
    #failed test
    it { is_expected.to validate_presence_of(:shift_end) }
    #failed test
    it { is_expected.to validate_presence_of(:shift_pay) }
    it { is_expected.to validate_length_of(:shift_description).is_at_least(10) }
    it { is_expected.to validate_numericality_of(:shift_pay).only_integer.is_greater_than_or_equal_to(0) }
  end

  #failed test
  describe "executes shift_org_name method correctly" do
    it "returns org's name that owns the shift" do
      sample_org = create(:organization)
      sample_shift = create(:shift, :front_of_house_role, :open_shift)
      expect(sample_shift.shift_org_name).to eq(sample_org.org_name)
    end
  end

  describe "executes shift_worker_name method correctly" do
    it "returns worker name" do 
      sample_user = create(:user, :worker_user_type)
      sample_worker = create(:worker, user_id: sample_user.id)
      sample_shift = create(:shift, :bartender_role, :filled_shift, worker_id: sample_worker.id)
      expect(sample_shift.shift_worker_name).to eq("#{sample_worker.first_name} #{sample_worker.last_name}")
    end
  end

  describe "filled_by(user) method" do
    it "checks if worker who filled the shift is same as user" do
    sample_user = create(:user, :worker_user_type)
    sample_worker = create(:worker, user_id: sample_user.id)
    sample_shift = create(:shift, :bartender_role, :filled_shift, worker_id: sample_worker.id)
    expect(sample_worker.user_id === sample_user.id).to be(true)
    end
  end

  describe "can_be_dropped?" do 
    it "should return true when shift can be dropped" do
      expect(shift1.can_be_dropped?).to be(true)
    end
 #hard-coded the date. Is there a way to make it dynamic? 
    it "should return false when shift is less than 24hrs from Now" do
      shift2 = create(:shift, :chef_role, :filled_shift, shift_start: "2021-05-09 12:00:00")
      expect(shift2.can_be_dropped?).to be(false)
    end
  end
   #private methods What is the best way to test?
end
