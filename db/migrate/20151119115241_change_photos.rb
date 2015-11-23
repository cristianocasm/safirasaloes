class ChangePhotos < ActiveRecord::Migration
  def change
    remove_column :photos, :customer_id
    remove_column :photos, :posted
    remove_column :photos, :schedule_id
    add_column :photos, :customer_telefone, :string
  end
end
