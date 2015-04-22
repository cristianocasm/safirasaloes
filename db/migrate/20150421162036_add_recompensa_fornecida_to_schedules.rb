class AddRecompensaFornecidaToSchedules < ActiveRecord::Migration
  def change
    add_column :schedules, :recompensa_fornecida, :boolean, default: false
  end
end
