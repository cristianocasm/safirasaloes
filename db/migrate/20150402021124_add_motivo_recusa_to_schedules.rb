class AddMotivoRecusaToSchedules < ActiveRecord::Migration
  def change
    add_column :schedules, :motivo_recusa, :text
  end
end
