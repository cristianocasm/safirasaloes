class ChangeHoraInSchedule < ActiveRecord::Migration
  def change
    rename_column :schedules, :hora, :datahora_inicio
    add_column    :schedules, :datahora_fim, :datetime
  end
end
