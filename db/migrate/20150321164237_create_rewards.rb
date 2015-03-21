class CreateRewards < ActiveRecord::Migration
  def change
    create_table :rewards do |t|
      t.integer :professional_id
      t.integer :customer_id
      t.integer :safiras

      t.timestamps
    end
    add_index :rewards, :professional_id
    add_index :rewards, :customer_id
  end
end
