class RemoveServiceIdFromSchedules < ActiveRecord::Migration
  def change
    remove_column :schedules, :service_id, :integer
  end
end
