RSpec.describe Importers::Order::Mapper do
  describe "#valid?" do
    context "when all attributes are present" do
      it "returns true" do
        subject = described_class.new(
          id: "123",
          merchant_reference: "456",
          amount: 0.5,
          created_at: Date.new(2021, 1, 1)
        )

        expect(subject.valid?).to be_truthy
      end
    end

    context "when any attribute is missing" do
      it "returns false" do
        subject = described_class.new(
          id: "123",
          merchant_reference: nil,
          amount: 40.50,
          created_at: Date.new(2021, 1, 1)
        )

        expect(subject.valid?).to be_falsey
      end
    end
  end

  describe "#merchant_id" do
    it "returns the merchant id" do
      merchant = create(:merchant, reference: "123")
      subject = described_class.new(merchant_reference: "123")

      expect(subject.merchant_id).to eq(merchant.id)
    end
  end

  describe "#amount_in_cents" do
    it "returns the amount in cents" do
      subject = described_class.new(amount: 0.5)
      expect(subject.amount_in_cents.to_i).to eq(50)

      subject = described_class.new(amount: 94.80)
      expect(subject.amount_in_cents.to_i).to eq(9480)

      subject = described_class.new(amount: 108.12)
      expect(subject.amount_in_cents.to_i).to eq(10812)
    end
  end

  describe "#commission_fee_in_cents" do
    it "returns the commission fee in cents" do
      allow(subject).to receive(:amount_in_cents).and_return(100)
      expect(subject.commission_fee_in_cents.to_i).to eq(1)

      allow(subject).to receive(:amount_in_cents).and_return(49_99)
      expect(subject.commission_fee_in_cents.to_i).to eq(49)

      allow(subject).to receive(:amount_in_cents).and_return(50_00)
      expect(subject.commission_fee_in_cents.to_i).to eq(47)

      allow(subject).to receive(:amount_in_cents).and_return(299_99)
      expect(subject.commission_fee_in_cents.to_i).to eq(284)

      allow(subject).to receive(:amount_in_cents).and_return(300_00)
      expect(subject.commission_fee_in_cents.to_i).to eq(255)
    end
  end
end
