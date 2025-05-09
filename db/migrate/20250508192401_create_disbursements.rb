class CreateDisbursements < ActiveRecord::Migration[8.0]
  def change
    create_table :disbursements do |t|
      t.uuid :reference, null: false, default: -> { "gen_random_uuid()" }
      t.references :merchant, null: false, foreign_key: true
      t.integer :amount_in_cents, null: false
      t.integer :commission_fee_in_cents, null: false

      t.timestamps
    end

    add_index :disbursements, :reference, unique: true
  end
end
