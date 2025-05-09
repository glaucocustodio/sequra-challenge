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

  scope :grouped_for_monthly_fee, ->(date_range) {
    where(placed_at: date_range)
      .joins(:merchant)
      .merge(Merchant.with_minimum_monthly_fee)
      .group("merchant_id, merchants.minimum_monthly_fee_in_cents")
      .select(
        "merchant_id",
        "merchants.minimum_monthly_fee_in_cents - SUM(commission_fee_in_cents) as monthly_fee_in_cents"
      )
      .having("SUM(commission_fee_in_cents) < merchants.minimum_monthly_fee_in_cents")
  }
end
