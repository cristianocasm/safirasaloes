class DropProfInfoAllowedFromPhotoLogs < ActiveRecord::Migration
  def change
    remove_column :photo_logs, :prof_info_allowed
  end
end
