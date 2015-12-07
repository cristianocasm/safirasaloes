class AddProfessionalIdToCustomerInvitation < ActiveRecord::Migration
  def change
    add_column :customer_invitations, :professional_id, :integer
    add_index :customer_invitations, :professional_id
  end
end
