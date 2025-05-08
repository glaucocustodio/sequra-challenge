module Importers
  module Order
    class Importer < Base
      def import
        total_imported_count = orders.each_slice(BATCH_SIZE).reduce(0) do |imported_count, orders|
          result = ::Order.insert_all(orders)
          imported_count + result.length
        end

        {imported_count: total_imported_count}
      end

      private

      BATCH_SIZE = 1000

      def orders = records.filter_map do |order|
        next unless order.valid?

        {
          external_id: order.external_id,
          merchant_id: order.merchant_id,
          amount_in_cents: order.amount_in_cents,
          placed_at: order.placed_at,
          commission_fee_in_cents: order.commission_fee_in_cents
        }
      end

      def mapper_class = Order::Mapper
    end
  end
end
