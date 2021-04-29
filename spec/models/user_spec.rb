require 'rails_helper'

RSpec.describe User, type: :model do
  let(:org_user) { create(:user) }
  let(:worker_user) { create(:user, :worker_user_type) }

  describe "validations" do
    subject { org_user }

    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:password).ignoring_interference_by_writer }
    it { is_expected.to validate_presence_of(:user_type) }
    it { is_expected.not_to allow_value("some_name@examplecom").for(:email) }
    it { is_expected.to validate_inclusion_of(:user_type).in_array(%w[organization worker]) }
    it { is_expected.to validate_length_of(:password).is_at_least(6) }
  end

  describe "has_org? method" do
    it "should return true when the organization_user has an associated organization account" do
      create(:organization, user_id: org_user.id)

      expect(org_user.has_org?).to be(true)
    end

    it "should return false when the organization_user does not have an associated organization account" do
      expect(org_user.has_org?).to be(false)
    end
  end

  describe "worker? method" do
    it "returns true when the worker_user has an associated worker account" do
      create(:worker, user_id: worker_user.id)

      expect(worker_user.worker?).to be(true)
    end

    it "returns false when the organization_user does not have an associated organization" do
      expect(worker_user.worker?).to be(false)
    end
  end

  describe "worker_account method" do
    it "should return the Worker Account for a worker-user if there is one" do
      sample_worker_account = create(:worker, user_id: worker_user.id)

      expect(worker_user.worker_account).to eq(sample_worker_account)
    end

    it "should return nil for a worker-user with no associated worker account" do
      expect(worker_user.worker_account).to eq(nil)
    end
  end
end
