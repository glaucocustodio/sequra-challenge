RSpec.describe MinimumMonthlyFee::Job do
  describe "#perform" do
    it "processes minimum monthly fees" do
      expect_any_instance_of(MinimumMonthlyFee::Processor).to receive(:process)

      subject.perform
    end
  end
end
