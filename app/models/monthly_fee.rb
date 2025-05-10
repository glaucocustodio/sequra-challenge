class MonthlyFee < ApplicationRecord
  include DateScopable

  belongs_to :merchant
end
