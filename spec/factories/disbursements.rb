FactoryBot.define do
  factory :disbursement do
    merchant
    amount_in_cents { Faker::Number.between(from: 1000, to: 10000) }
    commission_fee_in_cents { Faker::Number.between(from: 100, to: 1000) }
    as_of_date { Faker::Date.backward(days: 365) }
  end
end
