FactoryBot.define do
  factory :user, class: "User" do
    email { "org_user@example.com" }
    password  { "password123" }
    password_confirmation { "password123" }

    trait :org_user_type do
      user_type { "organization" }
    end

    trait :worker_user_type do
      user_type { "worker" }
    end
  end
end