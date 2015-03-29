class AddSafirasToExchangeOrders < ActiveRecord::Migration
  def change
    add_column :exchange_orders, :safiras, :integer
  end
end
