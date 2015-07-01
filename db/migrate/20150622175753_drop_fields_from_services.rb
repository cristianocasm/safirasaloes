class DropFieldsFromServices < ActiveRecord::Migration
  def change
    remove_column :services, :hora_duracao, :integer
    remove_column :services, :minuto_duracao, :integer
  end
end
