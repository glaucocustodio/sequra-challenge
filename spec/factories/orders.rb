FactoryBot.define do
  factory :order do
    external_id { SecureRandom.uuid.last(12) }
    merchant
    amount_in_cents { Faker::Number.between(from: 1000, to: 9000) }
    commission_fee_in_cents { amount_in_cents * 0.01 }
    placed_at { Faker::Time.between(from: 100.day.ago, to: Time.current) }

    trait :disbursed do
      disbursement
    end
  end
end
