require 'test_helper'

class CustomersControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    @request.env["devise.mapping"] = Devise.mappings[:customer]
  end

  test ":new sem convite redireciona para home page" do
    get :new
    assert_response :redirect
  end
  
  test ":new com convite renderiza layout login" do
    ci = customer_invitations(:convite)
    get :new, { customer: { email: ci.email, token: ci.token }}
    assert_response :success
    assert_template :new
    assert_template layout: 'layouts/login'
  end
end
