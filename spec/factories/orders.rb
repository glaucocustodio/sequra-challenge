FactoryBot.define do
  factory :order do
    uuid { SecureRandom.uuid }
    merchant
    amount_in_cents { Faker::Number.between(from: 1000, to: 9000) }
    placed_at { Faker::Time.between(from: 100.day.ago, to: Time.current) }
  end
end
