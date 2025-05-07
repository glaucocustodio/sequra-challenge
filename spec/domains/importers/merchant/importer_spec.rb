RSpec.describe Importers::Merchant::Importer do
  describe "#import" do
    context "when all merchants are valid" do
      it "imports the merchants" do
        tempfile = Tempfile.new(["merchants", ".csv"])
        tempfile.write(<<~CSV)
          id;reference;email;live_on;disbursement_frequency;minimum_monthly_fee
          a616488f-c8b2-45dd-b29f-364d12a20238;romaguera_and_sons;romaguera_and_sons@gmail.com;2020-01-01;DAILY;100.0
          a616488f-c8b2-45dd-b29f-364d12a20239;dooley_stracke;dooley_stracke@gmail.com;2024-10-15;WEEKLY;200.0
        CSV
        tempfile.rewind
        tempfile.close

        importer = described_class.new(csv_file_path: tempfile.path)
        importer.import

        expect(Merchant.count).to eq(2)
        expect(Merchant.order(:reference)).to contain_exactly(
          an_object_having_attributes(
            uuid: "a616488f-c8b2-45dd-b29f-364d12a20239",
            reference: "dooley_stracke",
            email: "dooley_stracke@gmail.com",
            live_on: Date.new(2024, 10, 15),
            disbursement_frequency: "weekly",
            minimum_monthly_fee: 200.0
          ),
          an_object_having_attributes(
            uuid: "a616488f-c8b2-45dd-b29f-364d12a20238",
            reference: "romaguera_and_sons",
            email: "romaguera_and_sons@gmail.com",
            live_on: Date.new(2020, 1, 1),
            disbursement_frequency: "daily",
            minimum_monthly_fee: 100.0
          )
        )
      end
    end

    context "when there are duplicates merchants in the file" do
      it "imports unique merchants" do
        tempfile = Tempfile.new(["merchants", ".csv"])
        tempfile.write(<<~CSV)
          id;reference;email;live_on;disbursement_frequency;minimum_monthly_fee
          a616488f-c8b2-45dd-b29f-364d12a20238;romaguera_and_sons;romaguera_and_sons@gmail.com;2020-01-01;DAILY;100.0
          a616488f-c8b2-45dd-b29f-364d12a20238;romaguera_and_sons;romaguera_and_sons@gmail.com;2020-01-02;WEEKLY;200.0
        CSV
        tempfile.rewind
        tempfile.close

        importer = described_class.new(csv_file_path: tempfile.path)
        importer.import

        expect(Merchant.count).to eq(1)
        expect(Merchant.order(:reference)).to contain_exactly(
          an_object_having_attributes(
            uuid: "a616488f-c8b2-45dd-b29f-364d12a20238",
            reference: "romaguera_and_sons",
            email: "romaguera_and_sons@gmail.com",
            live_on: Date.new(2020, 1, 1),
            disbursement_frequency: "daily",
            minimum_monthly_fee: 100.0
          )
        )
      end
    end

    context "when there are invalid merchants in the file" do
      it "imports only the valid merchants" do
        tempfile = Tempfile.new(["merchants", ".csv"])
        tempfile.write(<<~CSV)
          id;reference;email;live_on;disbursement_frequency;minimum_monthly_fee
          a616488f-c8b2-45dd-b29f-364d12a20238;romaguera_and_sons;romaguera_and_sons@gmail.com;2020-01-01;DAILY;100.0
          b616488f-c8b2-45dd-b29f-364d12a20238;;;2024-10-15;WEEKLY;200.0
          c616488f-c8b2-45dd-b29f-364d12a20238;dooley_stracke;dooley_stracke@gmail.com;2024-10-15;;200.0
          ;klocko_stanton_and_hammes;info@klocko-stanton-and-hammes.com;2022-11-18;DAILY;15.0
        CSV
        tempfile.rewind
        tempfile.close

        importer = described_class.new(csv_file_path: tempfile.path)
        importer.import

        expect(Merchant.count).to eq(1)
        expect(Merchant.order(:reference)).to contain_exactly(
          an_object_having_attributes(
            uuid: "a616488f-c8b2-45dd-b29f-364d12a20238",
            reference: "romaguera_and_sons",
            email: "romaguera_and_sons@gmail.com",
            live_on: Date.new(2020, 1, 1),
            disbursement_frequency: "daily",
            minimum_monthly_fee: 100.0
          )
        )
      end
    end
  end
end
