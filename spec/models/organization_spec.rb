require 'rails_helper'


RSpec.describe Organization, type: :model do
  let(:org) { create(:organization) }
  

  describe "validations" do
    subject { org }

    it { is_expected.to validate_presence_of(:org_name) }
    it { is_expected.to validate_presence_of(:org_description) }
    it { is_expected.to validate_presence_of(:org_address) }
    it { is_expected.to validate_presence_of(:org_city) }
    it { is_expected.to validate_presence_of(:org_state) }
    it { is_expected.to validate_uniqueness_of(:org_name).case_insensitive }
    it { is_expected.to validate_uniqueness_of(:org_address).case_insensitive }
    it { is_expected.to validate_length_of(:org_description).is_at_least(10) }
  end
  
end

