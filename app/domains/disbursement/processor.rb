module Disbursement
  class Processor
    def process
      merchants_for_disbursement.find_each do |merchant|
      end
    end

    def merchants_for_disbursement
      ::Order.eligible_for_disbursement.group(:merchant_id).count
    end
  end
end
