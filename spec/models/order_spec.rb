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

  describe ".grouped_for_disbursement" do
    it "returns orders grouped by merchant" do
      merchant1 = create(:merchant)
      merchant2 = create(:merchant)
      order1 = create(:order, merchant: merchant1, amount_in_cents: 10050, commission_fee_in_cents: 100)
      order2 = create(:order, merchant: merchant1, amount_in_cents: 25060, commission_fee_in_cents: 2500)
      order3 = create(:order, merchant: merchant2, amount_in_cents: 96050, commission_fee_in_cents: 960)
      order4 = create(:order, merchant: merchant2, amount_in_cents: 4590, commission_fee_in_cents: 45)
      orders = Order.all

      expect(Order).to receive(:eligible_for_disbursement).and_return(orders)

      expect(described_class.grouped_for_disbursement).to contain_exactly(
        an_object_having_attributes(
          merchant_id: merchant1.id,
          amount_in_cents: 32510,
          commission_fee_in_cents: 2600,
          order_ids: [order1.id, order2.id]
        ),
        an_object_having_attributes(
          merchant_id: merchant2.id,
          amount_in_cents: 99635,
          commission_fee_in_cents: 1005,
          order_ids: [order3.id, order4.id]
        )
      )
    end
  end

  describe ".grouped_for_monthly_fee" do
    it "returns orders grouped by merchant" do
      merchant1 = create(:merchant, minimum_monthly_fee_in_cents: 2000)
      merchant2 = create(:merchant, minimum_monthly_fee_in_cents: 5000)

      create(
        :order,
        merchant: merchant1,
        amount_in_cents: 10050,
        commission_fee_in_cents: 100,
        placed_at: Date.new(2025, 4, 1)
      )
      create(
        :order,
        merchant: merchant1,
        amount_in_cents: 25060,
        commission_fee_in_cents: 2500,
        placed_at: Date.new(2025, 4, 1)
      )
      create(
        :order,
        merchant: merchant2,
        amount_in_cents: 96050,
        commission_fee_in_cents: 960,
        placed_at: Date.new(2025, 4, 5)
      )
      create(
        :order,
        merchant: merchant2,
        amount_in_cents: 4590,
        commission_fee_in_cents: 45,
        placed_at: Date.new(2025, 4, 15)
      )
      create(
        :order,
        merchant: merchant2,
        amount_in_cents: 600000,
        commission_fee_in_cents: 6000,
        placed_at: Date.new(2025, 3, 15)
      )

      travel_to(Date.new(2025, 5, 6)) do
        expect(described_class.grouped_for_monthly_fee(Time.zone.today.last_month.all_month)).to(
          contain_exactly(
            an_object_having_attributes(
              merchant_id: merchant2.id,
              monthly_fee_in_cents: 3995
            )
          )
        )
      end
    end
  end
end
