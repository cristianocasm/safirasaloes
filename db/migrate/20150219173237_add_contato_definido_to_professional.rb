class AddContatoDefinidoToProfessional < ActiveRecord::Migration
  def change
    add_column :professionals, :contato_definido, :boolean
  end
end
