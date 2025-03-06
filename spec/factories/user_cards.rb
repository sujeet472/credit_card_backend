FactoryBot.define do
    factory :user_card do
      id { "UC#{rand(100..999)}" }
      # association :credit_card
      # association :profile
      association :credit_card, factory: :credit_card
      association :profile, factory: :profile

      issue_date { Date.today }
      expiry_date { Date.today + 5.years }
      is_active { true }
      available_limit { 10000.00 }
      cvv { '123' } # Virtual attribute for testing
      
    end
  end
  