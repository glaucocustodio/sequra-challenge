class DisbursementsController < ApplicationController
  def index
    @year = params.fetch(:year)
    @disbursements = Disbursement.for_year(@year).as_of_date_desc.includes(:merchant)
  end
end
