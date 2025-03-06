FactoryBot.define do
    factory :branch do
      branch_name { "Main Branch" }
      branch_address { "123 Main St" }
      branch_manager { "John Doe" }
      # branch_phone { "1234567890" }
      branch_phone { Faker::PhoneNumber.unique.cell_phone }
      # branch_email { "test@example.com" }
      branch_email { Faker::Internet.unique.email }
    end
  end
  