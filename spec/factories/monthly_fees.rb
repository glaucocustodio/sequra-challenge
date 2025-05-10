FactoryBot.define do
  factory :monthly_fee do
    merchant
    fee_in_cents { Faker::Number.between(from: 100, to: 1000) }
    as_of_date { Faker::Date.backward(days: 365) }
  end
end
