RSpec.describe Disbursement do
  describe ".yearly_summary" do
    it "returns the yearly summary of disbursements" do
      create(:disbursement, as_of_date: Date.new(2025, 1, 1), amount_in_cents: 1000, commission_fee_in_cents: 100)
      create(:disbursement, as_of_date: Date.new(2025, 2, 1), amount_in_cents: 4000, commission_fee_in_cents: 400)
      create(:disbursement, as_of_date: Date.new(2026, 1, 1), amount_in_cents: 3000, commission_fee_in_cents: 300)
      create(:disbursement, as_of_date: Date.new(2027, 10, 1), amount_in_cents: 6000, commission_fee_in_cents: 600)

      create(:monthly_fee, fee_in_cents: 200, as_of_date: Date.new(2025, 1, 1))
      create(:monthly_fee, fee_in_cents: 800, as_of_date: Date.new(2025, 2, 1))
      create(:monthly_fee, fee_in_cents: 320, as_of_date: Date.new(2026, 1, 1))

      expect(described_class.yearly_summary).to contain_exactly(
        an_object_having_attributes(
          year: 2025,
          disbursements_count: 2,
          amount_in_cents: 5000,
          commission_fee_in_cents: 500,
          monthly_fees_count: 2,
          monthly_fee_in_cents: 1000
        ),
        an_object_having_attributes(
          year: 2026,
          disbursements_count: 1,
          amount_in_cents: 3000,
          commission_fee_in_cents: 300,
          monthly_fees_count: 1,
          monthly_fee_in_cents: 320
        ),
        an_object_having_attributes(
          year: 2027,
          disbursements_count: 1,
          amount_in_cents: 6000,
          commission_fee_in_cents: 600,
          monthly_fees_count: 0,
          monthly_fee_in_cents: 0
        )
      )
    end
  end
end
