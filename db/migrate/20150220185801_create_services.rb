class CreateServices < ActiveRecord::Migration
  def change
    create_table :services do |t|
      t.string :nome
      t.string :preco
      t.integer :hora_duracao
      t.integer :minuto_duracao

      t.timestamps
    end
  end
end
