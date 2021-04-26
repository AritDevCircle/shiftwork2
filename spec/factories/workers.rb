FactoryBot.define do
  factory :worker do
    first_name { "Jon" }
    last_name  { "Snow" }
    worker_city { "Some City" }
    worker_state { "MD"}
    user_id { 1 }
  end
end