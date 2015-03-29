class DropExchangeOrdersTable < ActiveRecord::Migration
  def change
    drop_table :exchange_orders
  end
end
