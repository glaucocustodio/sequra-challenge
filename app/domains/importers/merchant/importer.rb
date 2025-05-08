module Importers
  module Merchant
    class Importer < Base
      def import
        result = ::Merchant.insert_all(merchants.to_a)

        {imported_count: result.length}
      end

      private

      def merchants
        records.filter_map do |merchant|
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

      def mapper_class = Merchant::Mapper
    end
  end
end
