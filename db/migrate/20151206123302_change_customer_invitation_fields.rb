class ChangeCustomerInvitationFields < ActiveRecord::Migration
  def change
    rename_column :customer_invitations, :token, :access_token
    add_column    :customer_invitations, :validation_token, :string
  end
end
