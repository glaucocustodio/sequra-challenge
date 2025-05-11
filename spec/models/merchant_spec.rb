RSpec.describe Merchant, type: :model do
  describe ".valid_disbursement_frequency?" do
    it "returns true for valid frequencies" do
      expect(described_class.valid_disbursement_frequency?("daily")).to be_truthy
      expect(described_class.valid_disbursement_frequency?("weekly")).to be_truthy
    end

    it "returns false for invalid frequencies" do
      expect(described_class.valid_disbursement_frequency?("monthly")).to be_falsey
      expect(described_class.valid_disbursement_frequency?("yearly")).to be_falsey
    end
  end

  describe ".on_weekday" do
    it "returns merchants that are weekly and on the current weekday" do
      merchant1 = create(:merchant, :weekly, live_on: Date.new(2025, 5, 6))
      merchant2 = create(:merchant, :weekly, live_on: Date.new(2025, 5, 7))

      travel_to(Date.new(2025, 5, 6)) do
        expect(described_class.on_weekday(date: Date.new(2025, 5, 6))).to contain_exactly(merchant1)
      end

      travel_to(Date.new(2025, 5, 7)) do
        expect(described_class.on_weekday(date: Date.new(2025, 5, 7))).to contain_exactly(merchant2)
      end
    end

    it "does not return merchants that are not weekly" do
      create(:merchant, :daily, live_on: Date.new(2025, 5, 6))

      travel_to(Date.new(2025, 5, 6)) do
        expect(described_class.on_weekday(date: Date.new(2025, 5, 6))).to be_empty
      end
    end
  end

  describe ".with_minimum_monthly_fee" do
    it "returns merchants that have a minimum monthly fee" do
      merchant1 = create(:merchant, minimum_monthly_fee_in_cents: 1000)
      merchant2 = create(:merchant, minimum_monthly_fee_in_cents: 2000)
      create(:merchant, minimum_monthly_fee_in_cents: 0)

      expect(described_class.with_minimum_monthly_fee).to contain_exactly(merchant1, merchant2)
    end
  end
end
