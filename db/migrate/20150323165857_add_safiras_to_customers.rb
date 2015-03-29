class AddSafirasToCustomers < ActiveRecord::Migration
  def change
    add_column :customers, :safiras, :integer, :default => 0
  end
end
