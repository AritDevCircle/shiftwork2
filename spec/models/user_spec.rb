require 'rails_helper'

RSpec.describe User, type: :model do
  let(:org_user) { create(:user, :org_user_type) }
  let(:worker_user) { create(:user, :worker_user_type) }
  let(:naked_org_user) { create(:user, :org_user_type) }
  let(:naked_worker_user) { create(:user, :org_user_type) }

  describe "has_org? method" do
    it "returns true when the organization_user has an associated organization account" do
      sample_org = create(:organization, user_id: org_user.id)

      expect(org_user.has_org?).to be(true)
    end

    it "returns false when the organization_user does not have an associated organization account" do
      expect(naked_org_user.has_org?).to be(false)
    end
  end

  describe "worker? method" do
    it "returns true when the worker_user has an associated worker account" do
      sample_worker = create(:worker, user_id: worker_user.id)
      
      expect(worker_user.worker?).to be(true)
    end

    it "returns false when the organization_user does not have an associated organization" do
      expect(naked_worker_user.worker?).to be(false)
    end
  end

  describe "worker_account method" do
    it "returns the Worker Account for a worker-user if there is one" do
      sample_worker = create(:worker, user_id: worker_user.id)

      expect(worker_user.worker_account).to eq(sample_worker)
    end

    it "returns nil for a worker-user with no associated worker account" do
      expect(naked_worker_user.worker_account).to eq(nil)
    end
  end
end
