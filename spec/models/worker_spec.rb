require 'rails_helper'

RSpec.describe Worker, type: :model do
	let(:test_worker) { create(:worker) }

	describe "validations" do
		subject { test_worker }

		it { is_expected.to validate_presence_of(:first_name) }
		it { is_expected.to validate_presence_of(:last_name) }
		it { is_expected.to validate_presence_of(:worker_city) }
		it { is_expected.to validate_presence_of(:worker_state) }
	end

    describe "associations" do
        it {should belong_to(:user)}
    end

	describe "worker_full_name method" do
		subject { test_worker }

		it {expect(test_worker.worker_full_name).to eq("Jon Snow")}
	end

end
