RSpec.describe Merchant, type: :model do
  describe ".valid_disbursement_frequency?" do
    it "returns true for valid frequencies" do
      expect(Merchant.valid_disbursement_frequency?("daily")).to be_truthy
      expect(Merchant.valid_disbursement_frequency?("weekly")).to be_truthy
    end

    it "returns false for invalid frequencies" do
      expect(Merchant.valid_disbursement_frequency?("monthly")).to be_falsey
      expect(Merchant.valid_disbursement_frequency?("yearly")).to be_falsey
    end
  end
end
