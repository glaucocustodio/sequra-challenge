module Importers
  module Order
    class Importer < Base
      def import
        ::Order.insert_all(orders)
      end

      private

      def orders = records.filter_map do |order|
        next unless order.valid?

        {
          uuid: order.uuid,
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
