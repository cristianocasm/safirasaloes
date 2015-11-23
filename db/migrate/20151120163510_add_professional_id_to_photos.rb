class AddProfessionalIdToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :professional_id, :integer
    add_index :photos, :professional_id
  end
end
