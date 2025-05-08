RSpec.describe Importers::Order::Importer do
  describe "#import" do
    context "when all orders are valid" do
      it "imports the orders" do
        merchant1 = create(:merchant, reference: "romaguera_and_sons")
        merchant2 = create(:merchant, reference: "dooley_stracke")

        tempfile = Tempfile.new(["orders", ".csv"])
        tempfile.write(<<~CSV)
          id;merchant_reference;amount;created_at
          a616488f-c8b2-45dd-b29f-364d12a20238;romaguera_and_sons;54.85;2020-01-01
          a616488f-c8b2-45dd-b29f-364d12a20239;dooley_stracke;74.69;2024-10-15
          c566488f-c8b2-45dd-b29f-364d12a45891;dooley_stracke;89.23;2022-04-10
        CSV
        tempfile.rewind
        tempfile.close

        importer = described_class.new(csv_file_path: tempfile.path)
        importer.import

        expect(Order.count).to eq(3)
        expect(Order.order(:placed_at)).to contain_exactly(
          an_object_having_attributes(
            uuid: "a616488f-c8b2-45dd-b29f-364d12a20238",
            merchant_id: merchant1.id,
            amount_in_cents: 5485,
            placed_at: Date.new(2020, 1, 1)
          ),
          an_object_having_attributes(
            uuid: "a616488f-c8b2-45dd-b29f-364d12a20239",
            merchant_id: merchant2.id,
            amount_in_cents: 7469,
            placed_at: Date.new(2024, 10, 15)
          ),
          an_object_having_attributes(
            uuid: "c566488f-c8b2-45dd-b29f-364d12a45891",
            merchant_id: merchant2.id,
            amount_in_cents: 8923,
            placed_at: Date.new(2022, 4, 10)
          )
        )
      end
    end

    context "when there are duplicates orders in the file" do
      it "imports unique orders" do
        merchant = create(:merchant, reference: "romaguera_and_sons")

        tempfile = Tempfile.new(["orders", ".csv"])
        tempfile.write(<<~CSV)
          id;merchant_reference;amount;created_at
          a616488f-c8b2-45dd-b29f-364d12a20238;romaguera_and_sons;54.85;2020-01-01
          a616488f-c8b2-45dd-b29f-364d12a20238;romaguera_and_sons;54.85;2020-01-01
          a616488f-c8b2-45dd-b29f-364d12a20239;romaguera_and_sons;74.69;2024-10-15
        CSV
        tempfile.rewind
        tempfile.close

        importer = described_class.new(csv_file_path: tempfile.path)
        importer.import

        expect(Order.count).to eq(2)
        expect(Order.order(:placed_at)).to contain_exactly(
          an_object_having_attributes(
            uuid: "a616488f-c8b2-45dd-b29f-364d12a20238",
            merchant_id: merchant.id,
            amount_in_cents: 5485,
            placed_at: Date.new(2020, 1, 1),
            commission_fee_in_cents: be_present
          ),
          an_object_having_attributes(
            uuid: "a616488f-c8b2-45dd-b29f-364d12a20239",
            merchant_id: merchant.id,
            amount_in_cents: 7469,
            placed_at: Date.new(2024, 10, 15),
            commission_fee_in_cents: be_present
          )
        )
      end
    end

    context "when some orders are invalid" do
      it "imports the valid orders" do
        merchant = create(:merchant, reference: "romaguera_and_sons")

        tempfile = Tempfile.new(["orders", ".csv"])
        tempfile.write(<<~CSV)
          id;merchant_reference;amount;created_at
          a616488f-c8b2-45dd-b29f-364d12a20238;romaguera_and_sons;54.85;2020-01-01
          a616488f-c8b2-45dd-b29f-364d12a20239;;74.69;2024-10-15
          ;dooley_stracke;89.23;2022-04-10
        CSV
        tempfile.rewind
        tempfile.close

        importer = described_class.new(csv_file_path: tempfile.path)
        importer.import

        expect(Order.count).to eq(1)
        expect(Order.order(:placed_at)).to contain_exactly(
          an_object_having_attributes(
            uuid: "a616488f-c8b2-45dd-b29f-364d12a20238",
            merchant_id: merchant.id,
            amount_in_cents: 5485,
            placed_at: Date.new(2020, 1, 1),
            commission_fee_in_cents: be_present
          )
        )
      end
    end
  end
end
