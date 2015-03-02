class RemoveRecompensaFidelidadeFromServices < ActiveRecord::Migration
  def change
    remove_column :services, :recompensa_fidelidade
  end
end
