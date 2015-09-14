class RemoveEmailFromCustomerInvitations < ActiveRecord::Migration
  def change
    remove_column :customer_invitations, :email, :integer
  end
end
