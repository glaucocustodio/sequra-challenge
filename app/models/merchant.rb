class Merchant < ApplicationRecord
  enum :disbursement_frequency, %w[daily weekly].index_by(&:itself), validate: true

  class << self
    def valid_disbursement_frequency?(frequency)
      frequency.in?(disbursement_frequencies.keys)
    end
  end
end
