class ChangeDisbursementsColumnsToBigint < ActiveRecord::Migration[8.0]
  def up
    change_column :disbursements, :amount_in_cents, :bigint
    change_column :disbursements, :commission_fee_in_cents, :bigint
  end

  def down
    change_column :disbursements, :amount_in_cents, :integer
    change_column :disbursements, :commission_fee_in_cents, :integer
  end
end
