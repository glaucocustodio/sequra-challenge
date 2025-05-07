class CreateMerchants < ActiveRecord::Migration[8.0]
  def change
    create_enum :merchant_disbursement_frequency, ["daily", "weekly"]

    create_table :merchants do |t|
      t.uuid :uuid, null: false
      t.string :reference, null: false
      t.string :email, null: false
      t.date :live_on, null: false
      t.enum :disbursement_frequency, enum_type: "merchant_disbursement_frequency", null: false
      t.float :minimum_monthly_fee, default: 0.0, null: false
      t.timestamps
    end

    add_index :merchants, :uuid, unique: true
    add_index :merchants, :reference, unique: true
  end
end
