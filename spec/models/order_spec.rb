RSpec.describe Order, type: :model do
  describe ".placed_today" do
    it "returns orders placed today" do
      _order_placed_yesterday = create(:order, placed_at: Date.new(2025, 5, 5))
      order_placed_today = create(:order, placed_at: Date.new(2025, 5, 6))

      travel_to(Date.new(2025, 5, 6)) do
        expect(described_class.placed_today).to contain_exactly(order_placed_today)
      end
    end
  end

  describe ".eligible_for_disbursement" do
    it "returns orders that are eligible for disbursement" do
      merchant_daily = create(:merchant, :daily)
      merchant_weekly = create(:merchant, :weekly)
      _order_placed_yesterday = create(:order, merchant: merchant_weekly, placed_at: Date.new(2025, 5, 5))
      order_placed_today = create(:order, merchant: merchant_daily, placed_at: Date.new(2025, 5, 6))

      travel_to(Date.new(2025, 5, 6)) do
        expect(described_class.eligible_for_disbursement).to contain_exactly(order_placed_today)
      end
    end
  end
end
