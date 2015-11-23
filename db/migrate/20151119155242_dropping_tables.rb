class DroppingTables < ActiveRecord::Migration
  def change
    drop_table :taken_steps
    drop_table :services
    drop_table :prices
    drop_table :admins
    drop_table :schedules
  end
end
