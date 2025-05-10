class MonthlyFeesController < ApplicationController
  def index
    @year = params.fetch(:year)
    @monthly_fees = MonthlyFee.for_year(@year).as_of_date_desc.includes(:merchant)
  end
end
