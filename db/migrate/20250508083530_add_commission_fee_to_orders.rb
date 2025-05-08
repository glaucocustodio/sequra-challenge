class AddCommissionFeeToOrders < ActiveRecord::Migration[8.0]
  def change
    add_column :orders, :commission_fee_in_cents, :integer, null: false, default: 0
  end
end
