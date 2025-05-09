class CreateMonthlyFees < ActiveRecord::Migration[8.0]
  def change
    create_table :monthly_fees do |t|
      t.references :merchant, null: false, foreign_key: true
      t.integer :fee_in_cents, null: false
      t.date :calculation_month, null: false

      t.timestamps
    end

    add_index :monthly_fees, [:merchant_id, :calculation_month], unique: true
  end
end
