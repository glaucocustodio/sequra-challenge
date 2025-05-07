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
          amount: order.amount,
          placed_at: order.placed_at
        }
      end

      def mapper_class = Order::Mapper
    end
  end
end
