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

require 'test_helper'

class CustomerInvitationTest < ActiveSupport::TestCase
  test "Criação gera Token" do
    invitation = CustomerInvitation.create({email: 'testtest@gmail.com'})
    assert_not_nil invitation.token
  end
end
