class AddTransacaoPagseguroToProfessionals < ActiveRecord::Migration
  def change
    add_column :professionals, :transacao_pagseguro, :string
  end
end
