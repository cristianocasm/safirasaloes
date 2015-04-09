require 'test_helper'

class CustomerInvitationTest < ActiveSupport::TestCase
  test "Criação gera Token" do
    invitation = CustomerInvitation.create({email: 'testtest@gmail.com'})
    assert_not_nil invitation.token
  end
end
