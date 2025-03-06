FactoryBot.define do
  factory :user do
    email { "test@example.com" }
    password { "password123" }
    confirmed_at { Time.current }  # Required for Devise confirmation
  end
end
