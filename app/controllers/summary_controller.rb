class SummaryController < ApplicationController
  def index
    @summary = Disbursement.yearly_summary
  end
end
