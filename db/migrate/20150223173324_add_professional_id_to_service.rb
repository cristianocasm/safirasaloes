class AddProfessionalIdToService < ActiveRecord::Migration
  def change
    add_column :services, :professional_id, :integer
    add_index :services, :professional_id
  end
end
