class DropExchangeOrderStatus < ActiveRecord::Migration
  def change
    drop_table :exchange_order_statuses
  end
end
