class Merchant < ApplicationRecord
  enum :disbursement_frequency, %w[daily weekly].index_by(&:itself), validate: true

  scope :eligible_for_disbursement, -> {
    daily.or(on_weekday)
  }

  scope :on_weekday, -> {
    weekly.where("EXTRACT(DOW FROM live_on) = ?", Time.current.wday)
  }

  class << self
    def valid_disbursement_frequency?(frequency)
      frequency.in?(disbursement_frequencies.keys)
    end
  end
end
