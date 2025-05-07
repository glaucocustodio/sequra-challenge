class Merchant < ApplicationRecord
  enum :disbursement_frequency, %w[daily weekly].index_by(&:itself), validate: true
end
