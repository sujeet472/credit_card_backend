FactoryBot.define do
    factory :credit_card do
      id { "CC#{rand(100..999)}" }
      type_of_card { %w[silver gold platinum].sample }
      credit_limit { Faker::Number.decimal(l_digits: 4, r_digits: 2) }
    end
  end
  