class Order < ApplicationRecord
  belongs_to :merchant

  scope :placed_today, -> { where(placed_at: Time.zone.today) }

  scope :eligible_for_disbursement, -> {
    placed_today
      .joins(:merchant)
      .merge(Merchant.eligible_for_disbursement)
  }
end
