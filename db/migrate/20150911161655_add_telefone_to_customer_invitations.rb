class AddTelefoneToCustomerInvitations < ActiveRecord::Migration
  def change
    add_column :customer_invitations, :telefone, :string
  end
end
