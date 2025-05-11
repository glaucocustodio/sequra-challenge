class OrdersController < ApplicationController
  def index
    @disbursement = Disbursement.find_by_reference(params.fetch(:disbursement_reference))
    @orders = @disbursement.orders.includes(:merchant).order(placed_at: :desc)
  end
end
