class CreateRewards < ActiveRecord::Migration
  def change
    create_table :rewards do |t|
      t.integer :service_id
      t.integer :quantidade_safiras

      t.timestamps
    end
    add_index :rewards, :service_id
  end
end
