class AddPriceIdToSchedules < ActiveRecord::Migration
  def change
    add_column :schedules, :price_id, :integer
    add_index :schedules, :price_id

    Schedule.reset_column_information
    # Define a chave estrangeira de prices
    # antes de deletar a chave estrangeira
    # de services
    Schedule.find_each do |sc|
      id = sc.service.prices.first.id
      sc.update_attribute(:price_id, id)
    end
  end
end
