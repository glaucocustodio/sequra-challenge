module DateScopable
  extend ActiveSupport::Concern

  included do
    scope :as_of_date_desc, -> { order(as_of_date: :desc) }
    scope :for_year, ->(year) { where("EXTRACT(YEAR FROM as_of_date) = ?", year) }
  end
end
