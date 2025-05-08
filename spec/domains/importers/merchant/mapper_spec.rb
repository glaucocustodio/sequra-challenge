RSpec.describe Importers::Merchant::Mapper do
  describe "#valid?" do
    context "when all attributes are present" do
      it "returns true" do
        subject = described_class.new(
          id: "123",
          reference: "456",
          email: "foo@bar.com",
          live_on: "2022-12-20",
          disbursement_frequency: "DAILY",
          minimum_monthly_fee: 78.80
        )

        expect(subject.valid?).to be_truthy
      end
    end

    context "when any attribute is missing" do
      it "returns false" do
        allow(subject).to receive(:id).and_return("123")
        allow(subject).to receive(:reference).and_return(nil)

        expect(subject.valid?).to be_falsey
      end
    end
  end

  describe "#disbursement_frequency" do
    context "when the disbursement frequency is valid" do
      it "returns the disbursement frequency" do
        subject = described_class.new(disbursement_frequency: "DAILY")

        expect(subject.disbursement_frequency).to eq("daily")
      end
    end

    context "when the disbursement frequency is invalid" do
      it "returns nil" do
        subject = described_class.new(disbursement_frequency: "INVALID")
        expect(subject.disbursement_frequency).to be_nil

        subject = described_class.new(disbursement_frequency: "")
        expect(subject.disbursement_frequency).to be_nil
      end
    end
  end
end
