module MinimumMonthlyFee
  class Processor
    def initialize(date: Time.zone.today)
      @date = date
    end

    def process
      ApplicationRecord.transaction do
        monthly_fee_groups.each do |group|
          create_monthly_fee_for(group)
        end
      end
    end

    private

    attr_reader :date

    def monthly_fee_groups = ::Order.grouped_for_monthly_fee(last_month_range)

    def last_month_range = date.last_month.all_month

    def create_monthly_fee_for(group)
      ::MonthlyFee.create!(
        merchant_id: group.merchant_id,
        fee_in_cents: group.monthly_fee_in_cents,
        as_of_date: last_month_range.begin
      )
    end
  end
end
