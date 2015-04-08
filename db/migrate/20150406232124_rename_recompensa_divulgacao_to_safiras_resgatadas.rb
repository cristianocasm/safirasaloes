class RenameRecompensaDivulgacaoToSafirasResgatadas < ActiveRecord::Migration
  def change
    rename_column :schedules, :recompensa_divulgacao, :safiras_resgatadas
  end
end
