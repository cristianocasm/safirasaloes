class AddDescriptionToPhotoLogs < ActiveRecord::Migration
  def change
    add_column :photo_logs, :description, :text
  end
end
