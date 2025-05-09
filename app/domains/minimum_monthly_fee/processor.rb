module MinimumMonthlyFee
  class Processor
    def process
      ApplicationRecord.transaction do
        monthly_fee_groups.each do |group|
          create_monthly_fee_for(group)
        end
      end
    end

    private

    def monthly_fee_groups = ::Order.grouped_for_monthly_fee(last_month_range)

    def last_month_range = Time.zone.today.last_month.all_month

    def create_monthly_fee_for(group)
      ::MonthlyFee.create!(
        merchant_id: group.merchant_id,
        fee_in_cents: group.monthly_fee_in_cents,
        calculation_month: last_month_range.begin
      )
    end
  end
end
