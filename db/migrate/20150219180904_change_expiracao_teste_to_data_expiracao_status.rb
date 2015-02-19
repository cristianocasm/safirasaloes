class ChangeExpiracaoTesteToDataExpiracaoStatus < ActiveRecord::Migration
  def change
    rename_column :professionals, :expiracao_teste, :data_expiracao_status
  end
end
