class AddPrecoFixoToServices < ActiveRecord::Migration
  def change
    add_column :services, :preco_fixo, :boolean, default: true
  end
end
