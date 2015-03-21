class CreateExchangeOrders < ActiveRecord::Migration
  def change
    create_table :exchange_orders do |t|
      t.integer :schedule_id
      t.integer :professional_id
      t.integer :customer_id
      t.integer :order_status_id

      t.timestamps
    end
    add_index :exchange_orders, :schedule_id
    add_index :exchange_orders, :professional_id
    add_index :exchange_orders, :customer_id
    add_index :exchange_orders, :order_status_id
  end
end
