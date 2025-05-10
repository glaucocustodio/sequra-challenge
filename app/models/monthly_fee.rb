class MonthlyFee < ApplicationRecord
  include DateScopable

  belongs_to :merchant

  monetize :fee_in_cents, as: "fee"
end
