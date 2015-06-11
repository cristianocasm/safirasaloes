class CreatePrices < ActiveRecord::Migration
  def change
    create_table :prices do |t|
      t.string :nome
      t.decimal :preco, precision: 8, scale: 2
      t.integer :recompensa_divulgacao, default: 0
      t.integer :service_id

      t.timestamps
    end
    add_index :prices, :service_id
  end
end
