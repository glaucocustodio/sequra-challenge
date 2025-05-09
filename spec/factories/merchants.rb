FactoryBot.define do
  factory :merchant do
    uuid { SecureRandom.uuid }
    reference { Faker::Company.name }
    email { Faker::Internet.email }
    live_on { Faker::Date.backward(days: 365) }
    disbursement_frequency { "daily" }
    minimum_monthly_fee_in_cents { Faker::Number.between(from: 1000, to: 10000) }

    trait :weekly do
      disbursement_frequency { "weekly" }
    end

    trait :daily do
      disbursement_frequency { "daily" }
    end
  end
end
