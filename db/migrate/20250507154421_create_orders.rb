class CreateOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :orders do |t|
      t.uuid :uuid, null: false
      t.references :merchant, null: false, foreign_key: true
      t.integer :amount, null: false
      t.date :placed_at, null: false

      t.timestamps
    end

    add_index :orders, :uuid, unique: true
  end
end
