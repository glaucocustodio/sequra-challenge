class AddDisbursementIdToOrders < ActiveRecord::Migration[8.0]
  def change
    add_reference :orders, :disbursement, foreign_key: true, null: true
  end
end
