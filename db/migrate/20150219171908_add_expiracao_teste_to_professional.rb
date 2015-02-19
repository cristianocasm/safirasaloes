class AddExpiracaoTesteToProfessional < ActiveRecord::Migration
  def change
    add_column :professionals, :expiracao_teste, :datetime
  end
end
