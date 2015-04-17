class AddFacebookFieldsToCustomer < ActiveRecord::Migration
  def change
    add_column :customers, :oauth_token, :string
    add_column :customers, :oauth_expires_at, :datetime
  end
end
