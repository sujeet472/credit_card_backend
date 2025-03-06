

# FactoryBot.define do
#   factory :profile do
#     sequence(:id) { |n| "P#{n.to_s.rjust(3, '0')}" }
#     first_name { "John" }
#     last_name { "Doe" }
#     date_of_birth { "1990-01-01" }
#     sequence(:email) { |n| "test#{n}@example.com" } # Ensure uniqueness
#     phone_number { Faker::PhoneNumber.cell_phone_in_e164[1..15] }
#     address { "123 Main St, City, Country" }
#     profile_image { nil }
#     account_type { "saving" }
#     association :user
#     association :branch
#   end
# end




