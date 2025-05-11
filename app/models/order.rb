class Order < ApplicationRecord
  belongs_to :merchant
  belongs_to :disbursement, optional: true

  scope :grouped_for_disbursement, ->(date:) {
    eligible_for_disbursement(date: date)
      .group(:merchant_id)
      .select(
        "merchant_id",
        "SUM(amount_in_cents) - SUM(commission_fee_in_cents) as amount_in_cents",
        "SUM(commission_fee_in_cents) as commission_fee_in_cents",
        "ARRAY_AGG(orders.id) as order_ids"
      )
  }

  scope :eligible_for_disbursement, ->(date:) {
    not_disbursed.eligible_for_disbursement_daily(date: date)
      .or(
        not_disbursed.eligible_for_disbursement_weekly(date: date)
      )
  }
  scope :eligible_for_disbursement_daily, ->(date:) {
    placed_on(date: date)
      .joins(:merchant)
      .merge(Merchant.daily)
  }
  scope :eligible_for_disbursement_weekly, ->(date:) {
    joins(:merchant)
      .merge(Merchant.on_weekday(date: date))
  }
  scope :placed_on, ->(date:) { where(placed_at: date) }
  scope :not_disbursed, -> { where(disbursement_id: nil) }

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

  scope :months_with_orders, -> {
    select("DATE_TRUNC('month', placed_at) AS placed_month")
      .group("DATE_TRUNC('month', placed_at)")
  }

  scope :grouped_by_placed_at, -> {
    group(:placed_at).select("placed_at")
  }
end
