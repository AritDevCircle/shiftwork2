FactoryBot.define do
  factory :shift do
    association :organization
    shift_start { "2021-12-30 12:00:00" }
    shift_end { "2021-12-30 15:00:00" }
    shift_pay { 22 }
    worker_id { nil }
  end

  trait :bartender_role do
    shift_role { "Bartender" }
    shift_description { "Mix all the drinks" }
  end

  trait :chef_role do
    shift_role { "Chef" }
    shift_description { "Cook all the food" }
  end

  trait :front_of_house_role do
    shift_role { "Front Of House" }
    shift_description { "Welcome all the guests" }
  end

  trait :filled_shift do
    shift_open { false }
  end

  trait :open_shift do
    shift_open { true }
  end
end