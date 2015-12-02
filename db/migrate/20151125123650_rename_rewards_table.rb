class RenameRewardsTable < ActiveRecord::Migration
  def change
    rename_column :rewards, :total_safiras, :safiras
    rename_table :rewards, :reward_logs
  end
end
