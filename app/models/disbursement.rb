class Disbursement < ApplicationRecord
  include DateScopable

  belongs_to :merchant

  has_many :orders

  monetize :amount_in_cents, as: "amount"
  monetize :commission_fee_in_cents, as: "commission_fee"

  scope :yearly_summary, -> {
    disbursements_subquery = <<~SQL
      SELECT
        CAST(EXTRACT(YEAR FROM as_of_date) AS int) AS year,
        COUNT(*) AS disbursements_count,
        SUM(amount_in_cents) AS amount_in_cents,
        SUM(commission_fee_in_cents) AS commission_fee_in_cents
      FROM disbursements
      GROUP BY year
    SQL

    monthly_fees_subquery = <<~SQL
      SELECT
        CAST(EXTRACT(YEAR FROM as_of_date) AS int) AS year,
        COUNT(*) AS monthly_fees_count,
        SUM(fee_in_cents) AS monthly_fee_in_cents
      FROM monthly_fees
      GROUP BY year
    SQL

    from("(#{disbursements_subquery}) disbursements")
      .joins("LEFT JOIN (#{monthly_fees_subquery}) monthly_fees ON disbursements.year = monthly_fees.year")
      .select(
        "disbursements.year",
        "disbursements.disbursements_count",
        "disbursements.amount_in_cents",
        "disbursements.commission_fee_in_cents",
        "COALESCE(monthly_fees.monthly_fees_count, 0) AS monthly_fees_count",
        "COALESCE(monthly_fees.monthly_fee_in_cents, 0) AS monthly_fee_in_cents"
      )
      .order("disbursements.year ASC")
  }
end
