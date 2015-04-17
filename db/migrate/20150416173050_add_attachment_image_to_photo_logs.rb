class AddAttachmentImageToPhotoLogs < ActiveRecord::Migration
  def self.up
    change_table :photo_logs do |t|
      t.attachment :image
    end
  end

  def self.down
    remove_attachment :photo_logs, :image
  end
end
