FactoryBot.define do
  factory :merchant do
    uuid { "" }
    reference { "MyString" }
    email { "MyString" }
    live_on { "2025-05-07" }
    disbursement_frequency { "MyString" }
    minimum_monthly_fee { "MyString" }
  end
end
