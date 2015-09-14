class AddScheduleIdAndRecoveredToCustomerInvitations < ActiveRecord::Migration
  def change
    add_column :customer_invitations, :schedule_id, :integer
    add_index :customer_invitations, :schedule_id
    add_column :customer_invitations, :recovered, :boolean, default: false
  end
end
