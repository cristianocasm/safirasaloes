require 'test_helper'

class Devise::ProfessionalRegistrationsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    @request.env["devise.mapping"] = Devise.mappings[:professional]
  end

  test ":new deve renderizar layout login" do
    get :new
    assert_response :success
    assert_template :new
    assert_template layout: 'layouts/login'
  end

  test ":create deve renderizar layout login" do
    put :create, professional: { email: 'testtest@test.com', password: 'testing', password_confirmation: 'testing' }
    assert_redirected_to root_path
  end

  test ":edit deve renderizar layout professional" do
    sign_in professionals(:aline)
    get :edit
    assert_response :success
    assert_template :edit
    assert_template layout: 'layouts/professional/professional'
  end

  test ":update deve renderizar layout professional" do
    @aline = professionals(:aline)
    sign_in @aline

    patch :update, id: @aline, professional: { nome: 'Test' }
    assert_redirected_to professional_root_path
  end

end