class Disbursement
  class Processor
    def initialize(date: Time.zone.today)
      @date = date
    end

    def process
      ApplicationRecord.transaction do
        disbursement_groups.each do |disbursement_group|
          disbursement = create_disbursement_for(disbursement_group)
          attach_orders_to_disbursement(disbursement_group, disbursement)
        end
      end
    end

    private

    attr_reader :date

    def disbursement_groups = ::Order.grouped_for_disbursement(date: date)

    def create_disbursement_for(disbursement_group)
      ::Disbursement.create!(
        merchant: disbursement_group.merchant,
        amount_in_cents: disbursement_group.amount_in_cents,
        commission_fee_in_cents: disbursement_group.commission_fee_in_cents,
        as_of_date: date
      )
    end

    def attach_orders_to_disbursement(disbursement_group, disbursement)
      Order.where(id: disbursement_group.order_ids).update_all(disbursement_id: disbursement.id)
    end
  end
end
