class ChangePriceFromStringToFloat < ActiveRecord::Migration
  def change
    remove_column :services, :preco
    add_column :services, :preco, :decimal, :precision => 8, :scale => 2
  end
end
