class AddShareCountToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :share_count, :integer, default: 0
  end
end
