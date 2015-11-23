class ChangeCustomerInvitations < ActiveRecord::Migration
  def change
    remove_column :customer_invitations, :schedule_id
    add_column :customer_invitations, :photo_id, :integer
    add_index :customer_invitations, :photo_id
  end
end
