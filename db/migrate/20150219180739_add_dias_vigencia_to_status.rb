class AddDiasVigenciaToStatus < ActiveRecord::Migration
  def change
    add_column :statuses, :dias_vigencia, :integer
  end
end
