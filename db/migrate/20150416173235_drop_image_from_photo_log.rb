class DropImageFromPhotoLog < ActiveRecord::Migration
  def change
    remove_column :photo_logs, :image
  end
end
