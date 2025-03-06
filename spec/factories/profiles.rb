FactoryBot.define do
    factory :profile do
      first_name { "John" }
      last_name { "Doe" }
      date_of_birth { "1990-01-01" }
      email { "john@example.com" }
      phone_number { "1234567890" }
      address { "123 Main Street, City" }
      profile_image { "profile.jpg" }
      account_type { "saving" }
      branch
      user
  
      after(:build) do |profile|
        profile.id ||= "P#{rand(100..999)}" # Assign a formatted ID
      end
    end
  end
  




