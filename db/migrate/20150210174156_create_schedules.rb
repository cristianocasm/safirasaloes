class CreateSchedules < ActiveRecord::Migration
  def change
    create_table :schedules do |t|
      t.integer :professional_id
      t.integer :customer_id
      t.integer :service_id
      t.datetime :hora

      t.timestamps
    end
    add_index :schedules, :professional_id
    add_index :schedules, :customer_id
    add_index :schedules, :service_id
  end
end
