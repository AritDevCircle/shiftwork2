FactoryBot.define do
  factory :organization do
    association :user
    sequence(:org_name) { |n| "Some Org ##{n}" }
    sequence(:org_description) { |n| "Some Org Description ##{n}" }
    org_address { "123 Some Street" }
    org_city { "Some City"}
    org_state { "MD" }
  end
end