class AddRecompensaDivulgacaoToSchedules < ActiveRecord::Migration
  def change
    add_column :schedules, :recompensa_divulgacao, :integer
  end
end
