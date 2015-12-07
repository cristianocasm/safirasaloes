# == Schema Information
#
# Table name: invitation_statuses
#
#  id         :integer          not null, primary key
#  nome       :string(255)      default("nVisto")
#  descricao  :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class InvitationStatus < ActiveRecord::Base
  has_many :customer_invitation
end
