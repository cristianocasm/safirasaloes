class AddPostedToPhotoLogs < ActiveRecord::Migration
  def change
    add_column :photo_logs, :posted, :boolean, :default => false
  end
end
