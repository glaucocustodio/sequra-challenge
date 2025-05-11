class Merchant < ApplicationRecord
  enum :disbursement_frequency, %w[daily weekly].index_by(&:itself), validate: true

  has_many :disbursements
  has_many :monthly_fees

  scope :on_weekday, ->(date:) {
    weekly.where("EXTRACT(DOW FROM live_on) = ?", date.wday)
  }

  scope :with_minimum_monthly_fee, -> {
    where("minimum_monthly_fee_in_cents > 0")
  }

  class << self
    def valid_disbursement_frequency?(frequency)
      frequency.in?(disbursement_frequencies.keys)
    end
  end
end
