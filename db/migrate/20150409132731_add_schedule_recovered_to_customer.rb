class AddScheduleRecoveredToCustomer < ActiveRecord::Migration
  def change
    add_column :customers, :schedule_recovered, :boolean, default: false
  end
end
