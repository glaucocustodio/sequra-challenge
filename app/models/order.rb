class Order < ApplicationRecord
  belongs_to :merchant
  belongs_to :disbursement, optional: true

  scope :placed_today, -> { where(placed_at: Time.zone.today) }

  scope :eligible_for_disbursement, -> {
    placed_today
      .joins(:merchant)
      .merge(Merchant.eligible_for_disbursement)
  }

  scope :grouped_for_disbursement, -> {
    eligible_for_disbursement
      .group(:merchant_id)
      .select(
        "merchant_id",
        "SUM(amount_in_cents) - SUM(commission_fee_in_cents) as amount_in_cents",
        "SUM(commission_fee_in_cents) as commission_fee_in_cents",
        "ARRAY_AGG(orders.id) as order_ids"
      )
  }
end
