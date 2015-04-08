class ChangeDefaultForSafirasResgatadas < ActiveRecord::Migration
  def change
    change_column_default :schedules, :safiras_resgatadas, 0
  end
end
