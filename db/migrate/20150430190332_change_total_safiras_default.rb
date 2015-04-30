class ChangeTotalSafirasDefault < ActiveRecord::Migration
  def change
    change_column_default :rewards, :total_safiras, 0
  end
end
