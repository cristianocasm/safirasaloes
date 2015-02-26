class AddRecompensaFidelidadeToServices < ActiveRecord::Migration
  def change
    rename_column :services, :recompensa, :recompensa_divulgacao
    add_column :services, :recompensa_fidelidade, :integer
  end
end
