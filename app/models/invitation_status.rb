class InvitationStatus < ActiveRecord::Base
  has_many :customer_invitation
end
