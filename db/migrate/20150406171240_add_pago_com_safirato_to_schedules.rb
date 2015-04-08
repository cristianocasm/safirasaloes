class AddPagoComSafiratoToSchedules < ActiveRecord::Migration
  def change
    add_column :schedules, :pago_com_safiras, :boolean, default: false
  end
end
