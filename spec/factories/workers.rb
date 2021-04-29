FactoryBot.define do
  factory :worker do
    association :user
    first_name { "Jon" }
    last_name  { "Snow" }
    worker_city { "Some City" }
    worker_state { "MD"}
  end
end