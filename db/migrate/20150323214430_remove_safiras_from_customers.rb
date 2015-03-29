class RemoveSafirasFromCustomers < ActiveRecord::Migration
  def change
    remove_column :customers, :safiras
  end
end
