module Importers
  module Order
    class Mapper < Shale::Mapper
      attribute :id, :string
      attribute :merchant_reference, :string
      attribute :amount, :float
      attribute :created_at, :date

      alias_method :placed_at, :created_at
      alias_method :external_id, :id

      def valid?
        [external_id, merchant_reference, amount, placed_at].all?(&:present?)
      end

      def merchant_id
        Rails.cache.fetch("merchant_id_for_reference_#{merchant_reference}") do
          ::Merchant.find_by_reference(merchant_reference).id
        end
      end

      # I assume all orders are in the default currency (EUR)
      # the default currency is set in the config/initializers/money.rb file
      def amount_in_cents = Money.from_amount(amount).cents

      # I assumed it's fine calculating the commission fee
      # at import time instead of at the time of disbursement
      def commission_fee_in_cents
        fee_percentage = COMMISSION_FEES.find {
          amount_in_cents.in?(_1[:order_amount_in_cents_range])
        }.fetch(:fee_percentage)

        (Money.from_cents(amount_in_cents) * fee_percentage).cents
      end

      private

      COMMISSION_FEES = [
        {
          order_amount_in_cents_range: 0..49_99,
          fee_percentage: 0.01
        },
        {
          order_amount_in_cents_range: 50_00..299_99,
          fee_percentage: 0.0095
        },
        {
          order_amount_in_cents_range: 300_00..,
          fee_percentage: 0.0085
        }
      ].freeze
    end
  end
end
