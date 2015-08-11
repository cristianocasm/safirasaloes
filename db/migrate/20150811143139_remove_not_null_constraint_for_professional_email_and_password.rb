class RemoveNotNullConstraintForProfessionalEmailAndPassword < ActiveRecord::Migration
  def change
    change_column :professionals, :email, :string, :null => true
    change_column :professionals, :encrypted_password, :string, :null => true
  end
end