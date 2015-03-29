class ChangeSafirasColumnNameInRewardsTable < ActiveRecord::Migration
  def change
    rename_column :rewards, :safiras, :total_safiras
  end
end
