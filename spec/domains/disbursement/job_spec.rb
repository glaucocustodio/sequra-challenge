RSpec.describe Disbursement::Job do
  describe "#perform" do
    it "processes disbursements" do
      expect_any_instance_of(Disbursement::Processor).to receive(:process)

      subject.perform
    end
  end
end
