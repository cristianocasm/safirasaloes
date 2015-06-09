require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  
  context "Customer" do
    setup do
      @request.env["devise.mapping"] = Devise.mappings[:customer]
    end

    should "Deve redirecionar para envio de fotos caso tenha sido atendido em tempo hábil" do
      sc = schedules :sch_cristiano_com_joao_service_barba
      ct = sc.customer
      put :create, customer: { email: ct.email, password: 'password' }
      assert_redirected_to new_photo_log_path
    end
  end
end