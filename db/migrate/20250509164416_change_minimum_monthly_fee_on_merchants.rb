class ChangeMinimumMonthlyFeeOnMerchants < ActiveRecord::Migration[8.0]
  def up
    change_column :merchants, :minimum_monthly_fee, :integer, default: 0, null: false
    rename_column :merchants, :minimum_monthly_fee, :minimum_monthly_fee_in_cents
  end

  def down
    change_column :merchants, :minimum_monthly_fee_in_cents, :float, default: 0.0, null: false
    rename_column :merchants, :minimum_monthly_fee_in_cents, :minimum_monthly_fee
  end
end
