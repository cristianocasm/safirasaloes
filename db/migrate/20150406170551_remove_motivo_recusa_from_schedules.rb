class RemoveMotivoRecusaFromSchedules < ActiveRecord::Migration
  def change
    remove_column :schedules, :motivo_recusa
  end
end
