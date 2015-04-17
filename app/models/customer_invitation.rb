# == Schema Information
#
# Table name: customer_invitations
#
#  id         :integer          not null, primary key
#  email      :string(255)
#  token      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class CustomerInvitation < ActiveRecord::Base
  has_secure_token :token

  scope :find_by_email_and_token, -> (email, token) { where("email = ? AND token = ?", email, token) }
end
