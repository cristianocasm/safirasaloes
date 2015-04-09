class CustomerInvitation < ActiveRecord::Base
  has_secure_token :token

  scope :find_by_email_and_token, -> (email, token) { where("email = ? AND token = ?", email, token) }
end
