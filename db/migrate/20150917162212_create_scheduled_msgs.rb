class CreateScheduledMsgs < ActiveRecord::Migration
  def change
    create_table :scheduled_msgs do |t|
      t.integer :schedule_id
      t.integer :api_id
    end
    add_index :scheduled_msgs, :schedule_id
  end
end
