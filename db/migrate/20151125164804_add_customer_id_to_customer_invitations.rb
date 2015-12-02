class AddCustomerIdToCustomerInvitations < ActiveRecord::Migration
  def change
    add_column :customer_invitations, :customer_id, :integer
    add_index :customer_invitations, :customer_id
  end
end
