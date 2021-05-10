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

	describe "worker_full_name method" do
		it "should return the first and last name of the worker, separated by a space" do
            expect(test_worker.worker_full_name).to eq("Jon Snow")
        end
	end

end
