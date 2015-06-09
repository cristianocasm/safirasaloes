require 'test_helper'

class Devise::SessionsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    @request.env["devise.mapping"] = Devise.mappings[:admin]
  end

  context "Telas Devise" do
    should ":new deve renderizar layout login_admin" do
      get :new
      assert_response :success
      assert_template :new
      assert_template layout: 'layouts/admin/login_admin'
    end

    should ":create deve renderizar layout login" do
      put :create, admin: { email: 'admin@admin.com', password: 'password' }
      assert_redirected_to admin_root_path
    end
  end

end