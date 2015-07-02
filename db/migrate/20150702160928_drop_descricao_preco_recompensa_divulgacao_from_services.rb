class DropDescricaoPrecoRecompensaDivulgacaoFromServices < ActiveRecord::Migration
  def change
    remove_column :services, :preco, :decimal
    remove_column :services, :recompensa_divulgacao, :integer
  end
end
