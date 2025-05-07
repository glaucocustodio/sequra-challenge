module Importers
  module Merchant
    class Mapper < Shale::Mapper
      attribute :id, :string
      attribute :reference, :string
      attribute :email, :string
      attribute :live_on, :date
      attribute :disbursement_frequency, :string
      attribute :minimum_monthly_fee, :float

      def valid?
        [uuid, reference, email, live_on, disbursement_frequency, minimum_monthly_fee].all?(&:present?)
      end

      def disbursement_frequency
        super&.downcase
      end

      alias_method :uuid, :id
    end
  end
end
