RSpec.describe MinimumMonthlyFee::Processor do
  describe "#process" do
    it "creates monthly fees for merchants with orders in the last month" do
      merchant1 = create(:merchant)
      merchant2 = create(:merchant)
      date_range = Time.zone.today.last_month.all_month

      expect(Order).to(
        receive(:grouped_for_monthly_fee).with(date_range).and_return([
          OpenStruct.new(
            merchant_id: merchant1.id,
            monthly_fee_in_cents: 1000
          ),
          OpenStruct.new(
            merchant_id: merchant2.id,
            monthly_fee_in_cents: 2000
          )
        ])
      )

      subject.process

      expect(MonthlyFee.order(:merchant_id)).to(
        contain_exactly(
          an_object_having_attributes(
            merchant_id: merchant1.id,
            fee_in_cents: 1000,
            calculation_month: date_range.begin
          ),
          an_object_having_attributes(
            merchant_id: merchant2.id,
            fee_in_cents: 2000,
            calculation_month: date_range.begin
          )
        )
      )
    end
  end
end
