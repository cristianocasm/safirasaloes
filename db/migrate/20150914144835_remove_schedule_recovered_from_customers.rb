class RemoveScheduleRecoveredFromCustomers < ActiveRecord::Migration
  def change
    remove_column :customers, :schedule_recovered, :boolean
  end
end
