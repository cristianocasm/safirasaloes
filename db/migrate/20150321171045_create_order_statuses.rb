class CreateOrderStatuses < ActiveRecord::Migration
  def change
    create_table :order_statuses do |t|
      t.string :nome
      t.string :descricao

      t.timestamps
    end
  end
end
