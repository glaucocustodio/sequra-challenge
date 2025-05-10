class AddAsOfDate < ActiveRecord::Migration[8.0]
  def change
    add_column :disbursements, :as_of_date, :date, null: false
    add_index :disbursements, [:merchant_id, :as_of_date], unique: true

    rename_column :monthly_fees, :calculation_month, :as_of_date
  end
end
