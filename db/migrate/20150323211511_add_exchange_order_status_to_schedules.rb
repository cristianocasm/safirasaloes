class AddExchangeOrderStatusToSchedules < ActiveRecord::Migration
  def change
    add_column :schedules, :exchange_order_status_id, :integer
    add_index :schedules, :exchange_order_status_id
  end
end
