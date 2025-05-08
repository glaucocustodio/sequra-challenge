class ChangeOrdersUuid < ActiveRecord::Migration[8.0]
  def up
    change_column :orders, :uuid, :string

    rename_column :orders, :uuid, :external_id
  end

  def down
    change_column :orders, :external_id, :uuid

    rename_column :orders, :external_id, :uuid
  end
end
