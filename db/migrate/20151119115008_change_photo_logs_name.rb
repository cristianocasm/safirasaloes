class ChangePhotoLogsName < ActiveRecord::Migration
  def change
    rename_table :photo_logs, :photos
  end
end
