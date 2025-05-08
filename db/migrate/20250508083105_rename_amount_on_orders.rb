class RenameAmountOnOrders < ActiveRecord::Migration[8.0]
  def change
    rename_column :orders, :amount, :amount_in_cents
  end
end
