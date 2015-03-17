class AddTelefoneToCustomers < ActiveRecord::Migration
  def change
    add_column :customers, :telefone, :string
  end
end
