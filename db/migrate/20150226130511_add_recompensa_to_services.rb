class AddRecompensaToServices < ActiveRecord::Migration
  def change
    add_column :services, :recompensa_divulgacao, :integer, default: 0
  end
end
