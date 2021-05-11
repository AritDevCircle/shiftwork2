require 'rails_helper'

RSpec.describe Shift, type: :model do
  let(:sample_shift) { create(:shift, :bartender_role, :filled_shift) }
  
  
  describe "validations" do
    subject { sample_shift }

    it { is_expected.to validate_presence_of(:shift_role) }
    it { is_expected.to validate_presence_of(:shift_description) }
    it { is_expected.to validate_presence_of(:shift_start) }
    it { is_expected.to validate_presence_of(:shift_end) }
    it { is_expected.to validate_presence_of(:shift_pay) }
    it { is_expected.to validate_length_of(:shift_description).is_at_least(10) }
    it { is_expected.to validate_numericality_of(:shift_pay).only_integer.is_greater_than_or_equal_to(0) }
  end


  describe "shift_org_name method" do
    it "should return the name of the organization that owns shift" do
      sample_shift = create(:shift, :front_of_house_role, :open_shift)
      shift_org = Organization.find(sample_shift.organization_id)
      expect(sample_shift.shift_org_name).to eq(shift_org.org_name)
    end
  end

  describe "shift_worker_name method" do
    it "should return the name of the worker assigned to shift" do 
      sample_user = create(:user, :worker_user_type)
      sample_worker = create(:worker, user_id: sample_user.id)
      sample_shift = create(:shift, :bartender_role, :filled_shift, worker_id: sample_worker.id)
      expect(sample_shift.shift_worker_name).to eq("#{sample_worker.first_name} #{sample_worker.last_name}")
    end
  end

  describe "filled_by(user) method" do
    it "should check if the worker assigned to the shift is the same as the current user" do
    sample_user = create(:user, :worker_user_type)
    sample_worker = create(:worker, user_id: sample_user.id)
    sample_shift = create(:shift, :bartender_role, :filled_shift, worker_id: sample_worker.id)
    expect(sample_shift.filled_by(sample_user)).to be(true)
    end
  end

  describe "can_be_dropped? method" do 
    it "should return true when the shift starts 24 hours or more from the current time" do
      sample_shift = create(:shift, :chef_role, :filled_shift, shift_start: DateTime.now + 72.hours, shift_end: DateTime.now + 78.hours)
      expect(sample_shift.can_be_dropped?).to be(true)
    end

    it "should return false when the shift starts less than 24hrs from the current time" do
      sample_shift = create(:shift, :chef_role, :filled_shift, shift_start: DateTime.now + 10.hours, shift_end: DateTime.now + 14.hours)
      expect(sample_shift.can_be_dropped?).to be(false)
    end
  end
end
