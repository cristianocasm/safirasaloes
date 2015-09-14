class RemoveTelefoneFromCustomerInvitations < ActiveRecord::Migration
  def change
    remove_column :customer_invitations, :telefone, :string
  end
end
