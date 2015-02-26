class AddRecompensaToServices < ActiveRecord::Migration
  def change
    add_column :services, :recompensa, :integer
  end
end
