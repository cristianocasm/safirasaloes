class AddProfInfoAllowedToPhotoLogs < ActiveRecord::Migration
  def change
    add_column :photo_logs, :prof_info_allowed, :boolean, default: false
  end
end
