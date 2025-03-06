FactoryBot.define do
    factory :account_transaction do
      association :user_card
      association :merchant, factory: :user_card
      transaction_date { Time.current }
      amount { Faker::Number.decimal(l_digits: 2, r_digits: 2) }
      location { Faker::Address.city }
      transaction_type { "purchase" }
    end
  end