class RemoveExchangeOrderStatusIdFromSchedules < ActiveRecord::Migration
  def change
    remove_column :schedules, :exchange_order_status_id
  end
end
