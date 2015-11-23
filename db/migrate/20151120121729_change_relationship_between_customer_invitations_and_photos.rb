class ChangeRelationshipBetweenCustomerInvitationsAndPhotos < ActiveRecord::Migration
  def change
    remove_column :photos, :safiras, :integer
    add_column :customer_invitations, :recompensa, :integer

    add_column :photos, :customer_invitation_id, :integer
    add_index :photos, :customer_invitation_id

    remove_column :customer_invitations, :photo_id, :integer
    
    remove_column :photos, :customer_telefone, :string
    add_column :customer_invitations, :customer_telefone, :string
  end
end
