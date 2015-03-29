class CreatePhotoLogs < ActiveRecord::Migration
  def change
    create_table :photo_logs do |t|
      t.integer :customer_id
      t.integer :professional_id
      t.integer :schedule_id
      t.integer :service_id
      t.integer :safiras

      t.timestamps
    end
    add_index :photo_logs, :customer_id
    add_index :photo_logs, :professional_id
    add_index :photo_logs, :schedule_id
    add_index :photo_logs, :service_id
  end
end
