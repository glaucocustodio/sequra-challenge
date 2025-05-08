RSpec.describe Disbursement::Processor do
  describe "#process" do
    it "disburses orders" do
      create(:order, amount: 10050)
      create(:order, amount: 25060)
      orders = Order.all
      expect(Order).to receive(:eligible_for_disbursement).and_return(orders)

      subject.process
    end
  end
end
