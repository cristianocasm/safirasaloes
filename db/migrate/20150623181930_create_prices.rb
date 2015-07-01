class CreatePrices < ActiveRecord::Migration
  def change
    create_table :prices do |t|
      t.string :descricao
      t.decimal :preco, :precision => 8, :scale => 2
      t.integer :recompensa_divulgacao
      t.integer :service_id

      t.timestamps
    end
    add_index :prices, :service_id

    # Migra informações dos campos a serem deletados
    # da tabela services (próxima migration) para
    # tabela prices
    Price.reset_column_information
    Service.find_each do |srv|
      prec = srv.preco
      reco = srv.recompensa_divulgacao

      srv.prices.create!(
        preco: prec,
        recompensa_divulgacao: reco
      )
    end
  end
end