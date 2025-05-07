module Importers
  module Merchant
    class Importer < Struct.new(:csv_file_path, keyword_init: true)
      def import
        ::Merchant.insert_all(merchants)
      end

      private

      def merchants
        mapped_merchants.filter_map do |merchant|
          next unless merchant.valid?

          {
            uuid: merchant.uuid,
            reference: merchant.reference,
            email: merchant.email,
            live_on: merchant.live_on,
            disbursement_frequency: merchant.disbursement_frequency,
            minimum_monthly_fee: merchant.minimum_monthly_fee
          }
        end
      end

      def mapped_merchants = Mapper.from_csv(csv_content, headers: true, col_sep: ";")

      def csv_content = ::File.read(csv_file_path)
    end
  end
end
