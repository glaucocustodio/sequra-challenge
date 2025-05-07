FactoryBot.define do
  factory :merchant do
    uuid { SecureRandom.uuid }
    reference { Faker::Company.name }
    email { Faker::Internet.email }
    live_on { Faker::Date.backward(days: 365) }
    disbursement_frequency { "daily" }
    minimum_monthly_fee { Faker::Number.between(from: 10, to: 100) }
  end
end
