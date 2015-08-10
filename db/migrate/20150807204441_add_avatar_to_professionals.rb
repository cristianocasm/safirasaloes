class AddAvatarToProfessionals < ActiveRecord::Migration
  def change
    add_column :professionals, :avatar_url, :string
  end
end
