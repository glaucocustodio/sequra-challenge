class Disbursement
  class Processor
    def initialize(date: Time.zone.today)
      @date = date
    end

    def process
      ApplicationRecord.transaction do
        disbursement_groups.each do |disbursement_group|
          disbursement_id = create_disbursement_for(disbursement_group)
          if disbursement_id
            attach_orders_to_disbursement(disbursement_group, disbursement_id)
          end
        end
      end
    end

    private

    attr_reader :date

    def disbursement_groups = ::Order.grouped_for_disbursement(date: date)

    def create_disbursement_for(disbursement_group)
      result = ::Disbursement.insert_all([
        {
          merchant_id: disbursement_group.merchant_id,
          amount_in_cents: disbursement_group.amount_in_cents,
          commission_fee_in_cents: disbursement_group.commission_fee_in_cents,
          as_of_date: date
        }
      ])
      result.rows.flatten.first.presence
    end

    def attach_orders_to_disbursement(disbursement_group, disbursement_id)
      Order.where(id: disbursement_group.order_ids).update_all(disbursement_id: disbursement_id)
    end
  end
end
