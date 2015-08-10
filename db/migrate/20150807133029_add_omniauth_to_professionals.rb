class AddOmniauthToProfessionals < ActiveRecord::Migration
  def change
    add_column :professionals, :provider, :string
    add_index :professionals, :provider
    add_column :professionals, :uid, :string
    add_index :professionals, :uid
  end
end
