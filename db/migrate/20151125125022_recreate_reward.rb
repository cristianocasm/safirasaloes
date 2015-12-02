class RecreateReward < ActiveRecord::Migration
  def change
    create_table :rewards do |t|
      t.integer :professional_id
      t.integer :customer_id
      t.integer :total_safiras, default: 0

      t.timestamps
    end
    add_index :rewards, :professional_id
    add_index :rewards, :customer_id
  end
end
