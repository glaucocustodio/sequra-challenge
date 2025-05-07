module Importers
  module Order
    class Mapper < Shale::Mapper
      attribute :id, :string
      attribute :merchant_reference, :string
      attribute :amount, :float
      attribute :created_at, :date

      def valid?
        [uuid, merchant_reference, amount, placed_at].all?(&:present?)
      end

      def merchant_id
        Rails.cache.fetch("merchant_id_for_reference_#{merchant_reference}") do
          ::Merchant.find_by_reference(merchant_reference).id
        end
      end

      def amount
        (super * 100).to_i # convert to cents
      end

      alias_method :placed_at, :created_at
      alias_method :uuid, :id
    end
  end
end
