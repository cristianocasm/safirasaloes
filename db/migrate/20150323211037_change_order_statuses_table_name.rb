class ChangeOrderStatusesTableName < ActiveRecord::Migration
  def change
    rename_table :order_statuses, :exchange_order_statuses
  end
end
