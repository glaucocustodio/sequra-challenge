RSpec.describe Disbursement::Processor do
  describe "#process" do
    it "disburses orders" do
      merchant1 = create(:merchant)
      merchant2 = create(:merchant)
      order1 = create(:order, merchant: merchant1)
      order2 = create(:order, merchant: merchant1)
      order3 = create(:order, merchant: merchant2)
      orders = [
        OpenStruct.new(
          merchant_id: merchant1.id,
          amount_in_cents: 10050,
          commission_fee_in_cents: 100,
          order_ids: [order1.id, order2.id]
        ),
        OpenStruct.new(
          merchant_id: merchant2.id,
          amount_in_cents: 25060,
          commission_fee_in_cents: 2500,
          order_ids: [order3.id]
        )
      ]
      expect(Order).to receive(:grouped_for_disbursement).and_return(orders)

      date = Date.new(2025, 1, 1)
      subject = described_class.new(date: date)
      subject.process

      expect(Disbursement.count).to eq(2)
      disbursements = Disbursement.all.order(:merchant_id)
      expect(disbursements).to contain_exactly(
        an_object_having_attributes(
          reference: be_present,
          merchant: merchant1,
          amount_in_cents: 10050,
          commission_fee_in_cents: 100,
          as_of_date: date
        ),
        an_object_having_attributes(
          reference: be_present,
          merchant: merchant2,
          amount_in_cents: 25060,
          commission_fee_in_cents: 2500,
          as_of_date: date
        )
      )
      expect(order1.reload.disbursement_id).to eq(disbursements.first.id)
      expect(order2.reload.disbursement_id).to eq(disbursements.first.id)
      expect(order3.reload.disbursement_id).to eq(disbursements.last.id)
    end
  end
end
