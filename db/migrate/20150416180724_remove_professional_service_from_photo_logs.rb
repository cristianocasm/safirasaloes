class RemoveProfessionalServiceFromPhotoLogs < ActiveRecord::Migration
  def change
    remove_column :photo_logs, :professional_id, :integer
    remove_column :photo_logs, :service_id, :integer
  end
end
