class AddPhotoIdToRewards < ActiveRecord::Migration
  def change
    add_column :rewards, :photo_id, :integer
    add_index :rewards, :photo_id
  end
end
