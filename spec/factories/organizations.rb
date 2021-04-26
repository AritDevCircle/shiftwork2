FactoryBot.define do
  factory :organization do
    org_name { "Some Org" }
    org_description  { "Some Org Description" }
    org_address { "123 Some Street" }
    org_city { "Some City"}
    org_state { "MD" }
    user_id { 1 }
  end
end