class AddFbFieldsToProfessionals < ActiveRecord::Migration
  def change
    add_column :professionals, :oauth_token, :string
    add_column :professionals, :oauth_expires_at, :datetime
  end
end
