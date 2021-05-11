FactoryBot.define do
  factory :user, class: "User" do
    sequence(:email) { |n| "user#{n}@example.com" }
    password  { "password123" }
    password_confirmation { "password123" }
    user_type { "organization" }
    timezone { "UTC" }

    trait :worker_user_type do
      user_type { "worker" }
    end
  end
end