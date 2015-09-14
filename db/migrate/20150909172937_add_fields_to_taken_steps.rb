class AddFieldsToTakenSteps < ActiveRecord::Migration
  def change
    add_column :taken_steps, :tela_listagem_servicos_acessada, :boolean, default: false
    add_column :taken_steps, :tela_edicao_servico_acessada, :boolean, default: false
  end
end
