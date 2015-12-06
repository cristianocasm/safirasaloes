class AddInvitationStatusIdToCustomerInvitations < ActiveRecord::Migration
  def change
    add_column :customer_invitations, :invitation_status_id, :integer
    add_index :customer_invitations, :invitation_status_id
  end
end
