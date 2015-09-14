# == Schema Information
#
# Table name: customer_invitations
#
#  id          :integer          not null, primary key
#  token       :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  schedule_id :integer
#  recovered   :boolean          default(FALSE)
#

class CustomerInvitation < ActiveRecord::Base
  has_secure_token :token

  before_create :limit_token

  belongs_to :schedule

  scope :find_by_schedule_and_token, -> (sc, token) { where("schedule_id = ? AND token = ? AND recovered = false", sc, token) }

  def limit_token
    self.token = self.token[0..3]
  end
end
