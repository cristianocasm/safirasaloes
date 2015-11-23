class ChangeScheduledMsgsRelationship < ActiveRecord::Migration
  def change
    remove_column :scheduled_msgs, :schedule_id
    add_column :scheduled_msgs, :customer_invitation_id, :integer
    add_index :scheduled_msgs, :customer_invitation_id
  end
end
