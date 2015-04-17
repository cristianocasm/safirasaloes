class AddImageToPhotoLogs < ActiveRecord::Migration
  def change
    add_column :photo_logs, :image, :string
  end
end
