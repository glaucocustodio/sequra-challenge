module Importers
  module Merchant
    class Mapper < Shale::Mapper
      attribute :id, :string
      attribute :reference, :string
      attribute :email, :string
      attribute :live_on, :date
      attribute :disbursement_frequency, :string
      attribute :minimum_monthly_fee, :float, default: -> { 0 }

      alias_method :uuid, :id

      def valid?
        [uuid, reference, email, live_on, disbursement_frequency, minimum_monthly_fee_in_cents].all?(&:present?)
      end

      # I assume all orders are in the default currency (EUR)
      # the default currency is set in the config/initializers/money.rb file
      def minimum_monthly_fee_in_cents = Money.from_amount(minimum_monthly_fee).cents

      def disbursement_frequency
        return if super.blank?
        downcased_frequency = super.downcase
        return unless ::Merchant.valid_disbursement_frequency?(downcased_frequency)

        downcased_frequency
      end
    end
  end
end
